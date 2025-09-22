#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# === This file is part of Calamares - <https://calamares.io> ===
#
#   SPDX-FileCopyrightText: 2025 Argent Linux
#   SPDX-License-Identifier: GPL-3.0-or-later
#
#   Calamares is Free Software: see the License-Identifier above.
#

import subprocess
import libcalamares
from libcalamares.utils import target_env_process_output
from libcalamares.utils import gettext_path, gettext_languages

import gettext
_translation = gettext.translation("calamares-python",
                                   localedir=gettext_path(),
                                   languages=gettext_languages(),
                                   fallback=True)
_ = _translation.gettext


def pretty_name():
    return _("Configuring Argent system.")


def pretty_status_message():
    return _("Running Argent post-installation configuration...")


def run():
    """
    Runs Argent-specific post-installation commands inside the chroot
    after user creation is complete.

    :return: None on success, or (error_title, error_message) on failure
    """
    
    username = libcalamares.globalstorage.value("username")
    if not username:
        error_msg = _("No username found in global storage")
        libcalamares.utils.warning(error_msg)
        return (_("Argent Post-Installation Error"), error_msg)
    
    libcalamares.utils.debug("Setting up Argent configuration for user: {}".format(username))
    
    argent_commands = [
        ["mkdir", "-p", "/home/{}/.config/systemd/user/default.target.wants".format(username)],
        ["mkdir", "-p", "/home/{}/.config/systemd/user/sockets.target.wants".format(username)],
        ["mkdir", "-p", "/home/{}/.config/systemd/user/pipewire.service.wants".format(username)],
        ["ln", "-sf", "/usr/lib/systemd/user/pipewire.service", "/home/{}/.config/systemd/user/default.target.wants/".format(username)],
        ["ln", "-sf", "/usr/lib/systemd/user/pipewire.socket", "/home/{}/.config/systemd/user/sockets.target.wants/".format(username)],
        ["ln", "-sf", "/usr/lib/systemd/user/pipewire-pulse.socket", "/home/{}/.config/systemd/user/sockets.target.wants/".format(username)],
        ["ln", "-sf", "/usr/lib/systemd/user/wireplumber.service", "/home/{}/.config/systemd/user/pipewire.service.wants/".format(username)],
        ["ln", "-sf", "/usr/lib/systemd/user/wireplumber.service", "/home/{}/.config/systemd/user/pipewire-session-manager.service".format(username)],
        ["chown", "-R", "{}:{}".format(username, username), "/home/{}/.config".format(username)]
    ]
    
    commands = libcalamares.job.configuration.get("commands", [])
    all_commands = argent_commands + commands
    
    libcalamares.utils.debug("Running {} total commands".format(len(all_commands)))
    
    for i, command in enumerate(all_commands):
        try:
            libcalamares.utils.debug("Executing command {}/{}: {}".format(i+1, len(all_commands), command))
            
            progress = (i + 1) / len(all_commands)
            libcalamares.job.setprogress(progress)
            
            if isinstance(command, str):
                cmd_list = command.split()
            else:
                cmd_list = command
            
            result = target_env_process_output(cmd_list)
            
        except subprocess.CalledProcessError as e:
            error_msg = _("Failed to execute command: {!s}\nReturn code: {!s}").format(command, e.returncode)
            libcalamares.utils.warning(error_msg)
            libcalamares.utils.debug("stdout: " + str(e.output))
            
            return (_("Argent Post-Installation Error"), error_msg)
        
        except Exception as e:
            error_msg = _("Unexpected error executing command: {!s}\nError: {!s}").format(command, str(e))
            libcalamares.utils.warning(error_msg)
            return (_("Argent Post-Installation Error"), error_msg)
    
    libcalamares.job.setprogress(1.0)
    libcalamares.utils.debug("Argent post-installation commands completed successfully")
    
    return None