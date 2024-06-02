import { readdir, existsSync } from 'fs';

const archList = ['aarch64', 'x86_64'];
const phpExtensions = [
  "bz2",
  "curl",
  "gd",
  "gmp",
  "ldap",
  "mysqlnd",
  "openssl",
  "pdo_mysql",
  "pdo_sqlite",
  "pdo_dblib",
  "pdo_pgsql",
  "pdo_odbc",
  "soap",
  "sodium",
  "calendar",
  "exif",
  "gettext",
  "intl",
  "mbstring",
  "opcache",
  "pcntl",
  "pdo",
  "phar",
  "sockets",
  "xsl",
  "bcmath",
  "ctype",
  "iconv",
  "dom",
  "pgsql",
  "posix",
  "shmop",
  "sysvmsg",
  "sysvsem",
  "sysvshm",
  "simplexml",
  "mysqli",
  "xml",
  "xmlreader",
  "xmlwriter",
  "fileinfo",
  "zip",
  "odbc",
  "ftp",
  "ffi",
  "fpm",
  "dev",
  "dbg",
  'cgi',
  'doc',
];

for (const arch of archList) {
  readdir(`./remote/${arch}`, (err, files) => {
    if (err) {
      console.error(err);
      return;
    }

    for (const file of files) {
      if (file.endsWith('.apk') === false) {
        continue;
      }

      const packageName = file.replace(/-\d+\.\d+.\d+-r\d+\.apk$/gm, '')

      if (packageName.includes('-config')) {
        continue;
      }

      let found = false

      for (const extension of phpExtensions) {
        if (packageName.endsWith(`-${extension}`)) {
          found = true;
          continue;
        }
      }

      if (found) {
        continue;
      }

      if (existsSync(`${packageName}.yaml`)) {
        continue;
      }


      console.log(`${arch}/${file} is not maintained anymore`)
    }
  });
}
