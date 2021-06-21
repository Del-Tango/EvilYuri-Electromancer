# EvilYuri-Electromancer

Evil Yuri is a command and control tool that allows one machine (known as the MasterMind machine) to obtain control over and manage any other number of machines (currently supported platform is Linux x64).

This is achieved via two other components that can be thought of as Yuri subsystems, the Evil Minion (used to scan the Conscript machine and phone home), and the HYpnotiK Payload (used to escalate privileges, open backdoor, cloak processes and phone home).

Yuri can run in one of three running modes: CLI, Util and Test. The default is CLI, here we get a numbered menu that the user can interact with upon executing (evil-yuri). Util running mode can only be configured from the (conf/evil-yuri.conf) file, and can be overriden by the CLI argument but cannot override CLI running mode. This way of using Yuri aids integration with other systems. The Test running mode runs the entire test suit using the previously mentioned configuration file as input data.

Deployments are accomplished via the means of an FTP server, this can either be the one Yuri comes built in with (vsftpd), or another one in a different location. All that is required is that you specify the external IPv4 address of the FTP server. Upon deployment of the HYpnotiK Payload, Yuri gets access to the Conscript shell via the backdoor set up by the Evil Minion, and issues a (wget) command to pull and execute the payload file.

Yuri also harvests the power of our WiFi Commander and Game Changer cargo scripts, for wireless network management and compiling shell scripts (used mainly on minions and payloads).

-- Component Subsystems --

    * Evil Minion (v1.0 Explorer)
        * [ DESCRIPTION      ]: Software used during Stage 1 of conscript recruitment. Uses generic commands to probe conscript machine.
        * [ MINION PATH      ]: minions/evil-minion.sh
        * [ PRIME DIRECTIVES ]:
            * Open Raw Socket Backdoor
                * Generated Raw Backdoor script and execute.
            * Scan Conscript Machine
                * username
                * OS
                * external IPv4
                * architecture
                * additional details
            * Phone Home
            * Set INIT at boot
            
    * HYpnotiK Payload (v1.0 Infiltrator)
        * [ DESCRIPTION      ]: Software used during Stage 2 of conscript recruitment. Uses intructions specific for conscript operating system, architecture and environment.
        * [ PAYLOAD PATH     ]: payloads/hypnotik-payload.sh
        * [ PRIME DIRECTIVES ]:
            * Open Backdoor
                * Protocol == raw
                    * Generated Raw Backdoor script and execute.
                * Protocol == ssh
                    * Creates dedicated system user and starts SSH server.
            * Escalate priviledges (via dictionary attack)
            * Install dependencies
            * Set INIT at boot
            * Create dedicated system user
            * Cloak HYpnotiK processes
            * Lift Evil Minion anchor (triggers Minion self destruct sequence)
            * Phone Home
            
            
More info at: alvearesolutions.wordpress.com

** DISCLAIMER **

Please do keep in mind that this product is meant to be used as another tool in your War Gaming tool set, and not for facilitating anti-social behaviour.
Neither I nor the Alveare Solutions society take any responsibily for damages of any kind resulting from the use of this product outside the context of a War Game!
Infecting machines you dont own to make them part of your botnet is a bad ideea in oh so many ways, but you look like a smart guy, you can figure that much.
