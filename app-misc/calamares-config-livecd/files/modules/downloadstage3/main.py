#!/usr/bin/env python3
import os
import shutil
import urllib.request
import tarfile
import subprocess
import libcalamares
import glob
import re
import sys
import time

def _progress_hook(count, block_size, total_size):
    _check_parent_alive()
    percent = int(count * block_size * 100 / total_size)
    if percent > 100:
        percent = 100
    libcalamares.job.setprogress(percent / 2)

def _check_parent_alive():
    if os.getppid() == 1:
        sys.exit(1)

def _find_latest_stage3(url):
    with urllib.request.urlopen(url) as response:
        html = response.read().decode('utf-8')
    matches = re.findall(r'(stage3-\w+-openrc-\d+T\d+Z\.tar\.xz)', html)
    matches = sorted(matches)
    if matches:
        return matches[-1]
    return None

def _safe_run(cmd):
    _check_parent_alive()
    try:
        proc = subprocess.Popen(cmd)
        while True:
            retcode = proc.poll()
            if retcode is not None:
                if retcode != 0:
                    sys.exit(1)
                return retcode
            if os.getppid() == 1:
                proc.terminate()
                try:
                    proc.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    proc.kill()
                sys.exit(1)
            time.sleep(1)
    except subprocess.SubprocessError:
        sys.exit(1)

def run():
    base_url = "https://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-openrc/"
    latest_tarball = _find_latest_stage3(base_url)
    if not latest_tarball:
        raise Exception("No stage3 tar.xz found!")

    full_tarball_url = base_url + latest_tarball
    full_sha256_url = base_url + latest_tarball + ".sha256"

    download_path = f"/mnt/{latest_tarball}"
    sha256_path = f"/mnt/{latest_tarball}.sha256"
    extract_path = "/mnt/gentoo-rootfs"

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
    if os.path.exists(sha256_path):
        os.remove(sha256_path)

    urllib.request.urlretrieve(full_tarball_url, download_path, _progress_hook)
    libcalamares.job.setprogress(40)
    urllib.request.urlretrieve(full_sha256_url, sha256_path)
    libcalamares.job.setprogress(50)

    _safe_run(["bash", "-c", f"cd /mnt && sha256sum -c {os.path.basename(sha256_path)}"])

    with tarfile.open(download_path, "r:xz") as tar:
        members = tar.getmembers()
        total_members = len(members)
        for i, member in enumerate(members):
            _check_parent_alive()
            tar.extract(member, extract_path)
            libcalamares.job.setprogress(50 + (i * 50 / total_members))

    os.remove(download_path)
    os.remove(sha256_path)

    shutil.copy2("/etc/resolv.conf", os.path.join(extract_path, "etc", "resolv.conf"))
    os.makedirs(os.path.join(extract_path, "etc/portage/binrepos.conf"), exist_ok=True)
    shutil.copy2(
        "/etc/portage/binrepos.conf/gentoobinhost.conf",
        os.path.join(extract_path, "etc/portage/binrepos.conf/gentoobinhost.conf")
    )

    _safe_run(["chroot", extract_path, "getuto"])

    package_use_dir = os.path.join(extract_path, "etc/portage/package.use")
    os.makedirs(package_use_dir, exist_ok=True)
    with open(os.path.join(package_use_dir, "00-livecd.package.use"), "w", encoding="utf-8") as f:
        f.write(">=sys-kernel/installkernel-50 dracut\n")

    _safe_run([
        "git", "clone", "--depth=1",
        "https://github.com/gentoo/gentoo.git",
        os.path.join(extract_path, "var/db/repos/gentoo")
    ])

    _safe_run(["mount", "--bind", "/proc", os.path.join(extract_path, "proc")])
    _safe_run(["mount", "--bind", "/sys", os.path.join(extract_path, "sys")])
    _safe_run(["mount", "--bind", "/dev", os.path.join(extract_path, "dev")])
    _safe_run(["mount", "--bind", "/run", os.path.join(extract_path, "run")])

    _safe_run([
        "chroot", extract_path, "/bin/bash", "-c",
        'EMERGE_DEFAULT_OPTS="${EMERGE_DEFAULT_OPTS} --getbinpkg" emerge -q sys-apps/dbus sys-boot/grub'
    ])

    for folder in ["distfiles", "binpkgs"]:
        path = os.path.join(extract_path, f"var/cache/{folder}")
        if os.path.exists(path):
            for entry in glob.glob(path + "/*"):
                if os.path.isfile(entry) or os.path.islink(entry):
                    os.unlink(entry)
                elif os.path.isdir(entry):
                    shutil.rmtree(entry)

    _safe_run(["umount", "-l", os.path.join(extract_path, "proc")])
    _safe_run(["umount", "-l", os.path.join(extract_path, "sys")])
    _safe_run(["umount", "-l", os.path.join(extract_path, "dev")])
    _safe_run(["umount", "-l", os.path.join(extract_path, "run")])

    return None
