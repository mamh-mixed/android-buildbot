#!/usr/bin/python
# v1.0
#    Load gfx autobuild
#    Author: yfshi@marvell.com

import os
import sys
import getopt
import subprocess
import datetime
from datetime import date

GFX_GIT = "ssh://shgit.marvell.com/git/qae/graphics/gfx_test_autobuild.git"
BRANCH_LIST =["pxa988_kk4.4", "pxa1928_kk4.4", "pxa1928_lp5.0"]
BUILD_STDIO = "/home/buildfarm/buildbot_script/stdio.log"

# return last build device from stdout log
def return_last_device(src_file, search):
    try:
        fp_src = open(src_file, 'r')
        fp_src.close()
    except IOError:
        print "failed to open file with read mode"
        exit(2)
    try:
        # return matching re
        arg = '''awk -F'=' '{if($1=="%s") print $2}' %s''' % (search, src_file)
        p = subprocess.Popen(arg, shell=True, stdout=subprocess.PIPE)
        (out, nothing) = p.communicate()
        return out.split()[len(out.split())-1]
    except IOError:
        print "failed searching"
        exit(2)

# sync the build code
def sync_build_code(repo_url):
    repo_folder = repo_url.split('.')[len(repo_url.split('.'))-2].split('/')[len(repo_url.split('.')[len(repo_url.split('.'))-2].split('/'))-1]
    if not os.path.isdir(repo_folder):
        subprocess.check_call('git clone %s' % repo_url, shell=True)
    else:
        subprocess.check_call('git fetch', shell=True, cwd=repo_folder)
        subprocess.check_call('git clean -d -f', shell=True, cwd=repo_folder)
        subprocess.check_call('git reset --hard origin/master', shell=True, cwd=repo_folder)
        subprocess.check_call('git checkout origin/master', shell=True, cwd=repo_folder)
    return "%s/%s" % (os.getcwd(), repo_folder)

def run(branch):
    # check if in branch list
    if not branch in BRANCH_LIST:
        print "%s do not request gfxtest build" % branch
        exit(255)
    # check if aabs build passed
    ret_p = os.system("grep \">PASS<\" %s" % BUILD_STDIO)
    ret_n = os.system("grep \">No build<\" %s" % BUILD_STDIO)
    if not (ret_p==0) or (ret_n==0):
        print "No AABS build, exit 255"
        exit(255)
    # git clone and build
    gfx_folder = sync_build_code(GFX_GIT)
    product = return_last_device(BUILD_STDIO, 'TARGET_PRODUCT')
    print gfx_folder
    print "Start load core.sh"
    print "branch: %s" % branch
    print "TARGET_PRODUCT: %s" % product
    cmd = "bash %s/core.sh %s %s %s" % (gfx_folder, "T", branch, product)
    print cmd
    os.system(cmd)
    exit(0)

#User help
def usage():
    print "\tgfxtest.py"
    print "\t      [-b] branch"
    print "\t      [-h] help"

def main(argv):
    branch = ""
    try:
        opts, args = getopt.getopt(argv,"b:n:h")
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-h"):
            usage()
            sys.exit()
        elif opt in ("-b"):
            branch = arg
    if not branch:
        usage()
        sys.exit(2)

    run(branch)

if __name__ == "__main__":
    main(sys.argv[1:])

