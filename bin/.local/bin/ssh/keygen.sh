echo "generate key for apple.shan"
ssh-keygen -t rsa -b 4096 -f id_rsa -C "apple.shan@gmail.com"

# 示例：
# 我在 GitHub
# ssh-keygen -t rsa -b 4096 -f id_rsa_github -C "me@github"
# ssh-keygen -t ed25519 -f id_ed25519_github  -C "me@github"
# 我在企业
# ssh-keygen -t ed25519 -f id_ed25519_company -C "email@example.com"

# Generating public/private rsa key pair.
# Enter file in which to save the key (/home/apple/.ssh/id_rsa):
# Enter passphrase (empty for no passphrase):
# Enter same passphrase again:
# Your identification has been saved in /home/apple/.ssh/id_rsa.
# Your public key has been saved in /home/apple/.ssh/id_rsa.pub.
# The key fingerprint is:
# SHA256:EA5Cq0at13VXvxeAmzzAUWAALmtefLFPt1K8Wg4yWp8 apple.shan@gmail.com
# The key's randomart image is:
# +---[RSA 4096]----+
# | .o ..o.o++..o   |
# |  .o.o ..o .. o  |
# | ..o .oo .o.o  o |
# |... = ..+ o=    o|
# |.o + + oS. +.  ..|
# |. + . . o o o   .|
# |   .   + + +     |
# |      o + B      |
# |     .   E .     |
# +----[SHA256]-----+
