#!/usr/bin/env python2

import os
import subprocess
import sys

def _read_pass(account_name, pass_name):
    actual_pass_name = os.path.join('offlineimap' , account_name, pass_name)
    cmd = ['pass', actual_pass_name]
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=sys.stderr)
    out, _ = p.communicate()
    return out.decode('utf-8')

def get_client_id(account_name):
    return _read_pass(account_name, 'oauth2_client_id')

def get_client_secret(account_name):
    return _read_pass(account_name, 'oauth2_client_secret')

def get_refresh_token(account_name):
    return _read_pass(account_name, 'oauth2_refresh_token')

def get_app_password(account_name):
    return _read_pass(account_name, 'app_password')

def get_web_password(account_name):
    cmd = ['pass', account_name]
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=sys.stderr)
    out, _ = p.communicate()
    # Web passwords have a password and a username on separate lines.
    # Only keep the password.
    out = out.split(b'\n')[0]
    return out.decode('utf-8')
