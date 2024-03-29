FROM cgr.dev/chainguard/wolfi-base:latest

RUN echo "https://wolfi.fos.gg" >> /etc/apk/repositories && \
cat <<EOF > /etc/apk/keys/php-signing.rsa.pub
-----BEGIN PUBLIC KEY-----
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA9s0rytmiqI5l6IgwLqiD
ecg3jwDIHWfzVmzfedTen4KW5MkmUVXgFXbmegD/e4arNzqkw2tpqIkYgKO4G5MF
wMvfvx4NP/dDBmEwRkqiq53+TfiaLZQYpotZy1Zrb7GHQBIQ+hK1ekN+WFBOmhd5
fwdPPBLbG1aOjigyydLdriLCDOf7mo7OZq7K42Ima2/Mp/Cdb12JswxIc5XYuJwX
35grsQy7dcli7QUbh20f/teB0hMb70V9RanXf2I8lzZ74djHMlDk6lJ0blBA8Wzl
P0m+yznoGIcSvix18XO78/TlbEajH/m8w4mjrNsgzeRlMeexOz0JO6fn7FtcRh3X
QmgAQ5QRy3ioZ1haEdr+oLlEOGUlmG1xdnpRCPAb8L0Xu7qDJr8Sm7DKPpzM5Jc4
k8/WCHJzsmOYPSV83itxTk6hfiMY5L/IsJsOe9/ZzUxmpiLEY5NSjiS+jSu/I492
PePYfiX/on7GNEzbRRaQzQ9cwKSKswpXxkk8dPQUTDPZ4SGclJzE0Yle/utQ4AJM
vMYK/ceaMC56CvEfoUmH3o2H0Y8MRhEE0hQ7xmIWlTfgJx256ToXG3auNVWs2Ax2
cwcAYarHaBAYoljBMyCqMWW+7nLCXoI0bAb0O4f2X2I6zpD2MsE7obLQA6l6x/X+
og/rYbYh7rDgqPyhAU8tJicCAwEAAQ==
-----END PUBLIC KEY-----
EOF
