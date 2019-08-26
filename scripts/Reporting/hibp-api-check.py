import pwnedpasswords
import sys

# Usage: run this python script and provide the file name with passwords to check.
# Example: python passwords.txt

fileName = sys.argv[1]
count = 0.0
pwnedCount = 0.0

file = open(fileName, "r")
fileList = file.read().splitlines()

for password in fileList:
    result = pwnedpasswords.check(password)
    print("Checked Password: %s COUNT: %s" % (password, result))
    if result > 0:
        pwnedCount += 1.0
    count += 1.0


pwnedPercent = (pwnedCount / count) * 100
print("\n")
print("========")
print("DONE")
print("========")
print("\n")
print("Number of passwords checked: %d" % count)
print("Number of passwords pwned: %d" % pwnedCount)
print("Percentage of pwned passwords: %d" % pwnedPercent)

