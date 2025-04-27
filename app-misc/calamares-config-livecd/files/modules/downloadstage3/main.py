#!/usr/bin/env python3
import os
import shutil
import urllib.request
import tarfile
import subprocess
import libcalamares
import glob

def _progress_hook(count, block_size, total_size):
    percent = int(count * block_size * 100 / total_size)
    if percent > 100:
        percent = 100
    libcalamares.job.setprogress(percent / 2)

def run():
    url = "https://distfiles.gentoo.org/releases/amd64/autobuilds/20250420T121009Z/stage3-amd64-openrc-20250420T121009Z.tar.xz"
    download_path = "/tmp/stage3.tar.xz"
    extract_path = "/tmp/gentoo-rootfs"

    if os.path.exists(extract_path):
        for entry in os.listdir(extract_path):
            path = os.path.join(extract_path, entry)
            if os.path.isfile(path) or os.path.islink(path):
                os.unlink(path)
            elif os.path.isdir(path):
                shutil.rmtree(path)
    else:
        os.makedirs(extract_path, exist_ok=True)

    if os.path.exists(download_path):
        os.remove(download_path)

    urllib.request.urlretrieve(url, download_path, _progress_hook)
    libcalamares.job.setprogress(50)

    with tarfile.open(download_path, "r:xz") as tar:
        members = tar.getmembers()
        total_members = len(members)
        for i, member in enumerate(members):
            tar.extract(member, extract_path)
            libcalamares.job.setprogress(50 + (i * 50 / total_members))

    shutil.copy2("/etc/resolv.conf", os.path.join(extract_path, "etc", "resolv.conf"))

    package_use_dir = os.path.join(extract_path, "etc/portage/package.use")
    os.makedirs(package_use_dir, exist_ok=True)
    with open(os.path.join(package_use_dir, "00-livecd.package.use"), "w", encoding="utf-8") as f:
        f.write(">=sys-kernel/installkernel-50 dracut\n")

    subprocess.run(["mount", "--bind", "/proc", os.path.join(extract_path, "proc")], check=True)
    subprocess.run(["mount", "--bind", "/sys", os.path.join(extract_path, "sys")], check=True)
    subprocess.run(["mount", "--bind", "/dev", os.path.join(extract_path, "dev")], check=True)
    subprocess.run(["mount", "--bind", "/run", os.path.join(extract_path, "run")], check=True)

    try:
        subprocess.run(["chroot", extract_path, "emerge", "--sync"], check=True)
    except subprocess.CalledProcessError:
        pass

    try:
        subprocess.run(["chroot", extract_path, "emerge", "-v", "sys-apps/dbus", "sys-boot/grub", "sys-kernel/gentoo-kernel-bin"], check=True)
    except subprocess.CalledProcessError:
        pass

    subprocess.run(["rm", "-rf", os.path.join(extract_path, "var/db/repos/gentoo")])

    distfiles_path = os.path.join(extract_path, "var/cache/distfiles")
    if os.path.exists(distfiles_path):
        for entry in glob.glob(distfiles_path + "/*"):
            if os.path.isfile(entry) or os.path.islink(entry):
                os.unlink(entry)
            elif os.path.isdir(entry):
                shutil.rmtree(entry)

    subprocess.run(["umount", "-l", os.path.join(extract_path, "proc")])
    subprocess.run(["umount", "-l", os.path.join(extract_path, "sys")])
    subprocess.run(["umount", "-l", os.path.join(extract_path, "dev")])
    subprocess.run(["umount", "-l", os.path.join(extract_path, "run")])

    return None
