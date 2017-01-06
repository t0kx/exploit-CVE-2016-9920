# Roundcube 1.0.0 &lt;= 1.2.2 Remote Code Execution

Roundcube is a widely distributed open-source webmail software used by many organizations and companies around the globe. The mirror on SourceForge, for example, counts more than 260,000 downloads in the last 12 months which is only a small fraction of the actual users. Once Roundcube is installed on a server, it provides a web interface for authenticated users to send and receive emails with their web browser.

In Roundcube 1.2.2, and earlier, user-controlled input flows unsanitized into the fifth argument of a call to PHP's built-in function mail() which is documented as security critical. The problem is that the invocation of the mail() function will cause PHP to execute the sendmail program. The fifth argument allows to pass arguments to this execution which allows a configuration of sendmail. Since sendmail offers the -X option to log all mail traffic in a file, an attacker can abuse this option and spawn a malicious PHP file in the webroot directory of the attacked server. The following code lines trigger the vulnerability.

## Requirements

The vulnerability has the following requirements for exploitation:

* Roundcube must be configured to use PHP’s `mail()` function (by default, if no SMTP was specified [1])
* PHP’s `mail()` function is configured to use sendmail (by default, see sendmail_path [2])
* PHP is configured to have `safe_mode` turned off (by default, see safe_mode [3])
* An attacker must know or guess the absolute path of the webroot

These requirements are not particular demanding which in turn means that there were a lot of vulnerable systems in the wild.

## Vulnerable environment

To setup a vulnerable environment for your test you will need [Docker](https://docker.com) installed, and just run the following command:

    docker build -t vuln/cve-2016-9920 .
    docker run --rm -it -p 80:80 vuln/cve-2016-9920

And it will spawn a vulnerable web application on your host on ```80``` port

## Vulnerable code

> In Roundcube 1.2.2 and earlier, user-controlled input flows unsanitized into the fifth argument of a call to PHP’s built-in function `mail()` which is documented as critical in terms of security. The problem is that the invocation of the `mail()` function will cause PHP to execute the sendmail program. The fifth argument allows passing additional parameters to this execution which allows a configuration of sendmail. Since sendmail offers the `-X` option to log all mail traffic in a file, an attacker can abuse this option and spawn a malicious PHP file in the webroot directory of the attacked server. Although this vulnerability is rare and not widely known, RIPS detected it within seconds. [4]

## Exploit

To exploit this target just run:

    ./exploit.py --host HOST --user USERNAME --pwd PASSWORD --path PATH --www_path WEB_DIRECTORY

If you are using this vulnerable image, you can just run:

    ./exploit.py --host 127.0.0.1 --user username --pwd password --path roundcube --www_path "/var/www/html/roundcube"

After the exploitation, a file called backdoor.php will be stored on the root folder of the web directory. And the exploit will drop you a shell where you can send commands to the backdoor:

    ./exploit.py --host 127.0.0.1 --user username --pwd password --path roundcube --www_path "/var/www/html/roundcube"
    [+] CVE-2016-9920 exploit by t0kx
    [+] Exploiting 127.0.0.1
    [+] Target exploited, acessing shell at http://127.0.0.1/roundcube/backdoor.php
    [+] Running whoami: www-data
    [+] Done

## Credits

This flaw was found by Robin Peraglie [4]. The main text and the idea of this education stuff was created by opsxcq.

## Disclaimer

This or previous program is for Educational purpose ONLY. Do not use it without permission. The usual disclaimer applies, especially the fact that me (t0kx) is not liable for any damages caused by direct or indirect use of the information or functionality provided by these programs. The author or any Internet provider bears NO responsibility for content or misuse of these programs or any derivatives thereof. By using these programs you accept the fact that any damage (dataloss, system crash, system compromise, etc.) caused by the use of these programs is not t0kx's responsibility.

## Links

* [1] https://github.com/roundcube/roundcubemail/wiki/Configuration#sending-messages-via-smtp
* [2] http://php.net/manual/en/mail.configuration.php
* [3] http://php.net/manual/en/ini.sect.safe-mode.php
* [4] https://blog.ripstech.com/2016/roundcube-command-execution-via-email/
