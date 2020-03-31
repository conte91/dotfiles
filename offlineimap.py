import os
import subprocess
import sys

def _read_pass(account_name, pass_name):
    actual_pass_name = os.path.join('offlineimap' , account_name, pass_name)
    cmd = ['pass', actual_pass_name]
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=sys.stderr)
    out, _ = p.communicate()
    return out

def get_client_id(account_name):
    return _read_pass(account_name, 'oauth2_client_id')

def get_client_secret(account_name):
    return _read_pass(account_name, 'oauth2_client_secret')

def get_refresh_token(account_name):
    return _read_pass(account_name, 'oauth2_refresh_token')
