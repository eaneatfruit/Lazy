import pwnedpasswords
import sys
import argparse

# Usage: run this python script 
# Example: python passwords.txt

parser = argparse.ArgumentParser(description='Checks HaveIBeenPwned API to see if users passwords have appeared in databreaches.')
parser.add_argument('-u', '--users', action='store_true', help='Toggles username support. If this switch is specified the input list will be in the format username:password')
parser.add_argument('-i', '--input', help='Input list containing passwords or username:password credential pairs.')
args = parser.parse_args()


if len(sys.argv) < 2:
    print("Insufficient arguments, password list not provided!")
    exit(1)

count = 0.0
pwnedCount = 0.0
pwnedUsers = []

print("===== PWNED PASSWORD CHCECKER =====\n")

file = open(args.input, "r")
fileList = file.read().splitlines()

for password in fileList:
    if args.users:
        thisPassword = password.split(":",1)[1]
        result = pwnedpasswords.check(thisPassword)
        print("Checked Password: %s COUNT: %s" % (thisPassword, result))
        if result > 0:
            pwnedUsers.append(password.split(":",1)[0])
    else: 
        result = pwnedpasswords.check(password)
        print("Checked Password: %s COUNT: %s" % (password, result))
    if result > 0:
        pwnedCount += 1.0
    count += 1.0


pwnedPercent = (pwnedCount / count) * 100
print("\n========")
print("DONE")
print("========\n")
print("Number of passwords checked: %d" % count)
print("Number of passwords pwned: %d" % pwnedCount)
print("Percentage of pwned passwords: %d" % pwnedPercent)
if len(pwnedUsers) > 0: 
    print("\n\n=====List of Users with Pwned Passwords=====\n")
    for user in pwnedUsers:
        print("* %s" % user)



