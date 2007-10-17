package Parse::IASLog;

use strict;

# We export some stuff
require Exporter;
our @ISA = qw( Exporter );
our @EXPORT = qw(parse_ias);

use vars qw($VERSION);

$VERSION = '0.01';

my %attributes = qw(
1 User-Name
4 NAS-IP-Address
5 NAS-Port
6 Service-Type
7 Framed-Protocol
8 Framed-IP-Address
9 Framed-IP-Netmask
10 Framed-Routing
11 Filter-ID
12 Framed-MTU
13 Framed-Compression
14 Login-IP-Host
15 Login-Service
16 Login-TCP-Port
18 Reply-Message
19 Callback-Number
20 Callback-ID
22 Framed-Route
23 Framed-IPX-Network
25 Class
26 Vendor-Specific
27 Session-Timeout
28 Idle-Timeout
29 Termination-Action
30 Called-Station-ID
31 Calling-Station-ID
32 NAS-Identifier
34 Login-LAT-Service
35 Login-LAT-Node
36 Login-LAT-Group
37 Framed-AppleTalk-Link
38 Framed-AppleTalk-Network
39 Framed-AppleTalk-Zone
40 Acct-Status-Type
41 Acct-Delay-Time
42 Acct-Input-Octets
43 Acct-Output-Octets
44 Acct-Session-ID
45 Acct-Authentic
46 Acct-Session-Time
47 Acct-Input-Packets
48 Acct-Output-Packets
49 Acct-Terminate-Cause
50 Acct-Multi-SSN-ID
51 Acct-Link-Count
55 Event-Timestamp
61 NAS-Port-Type
62 Port-Limit
63 Login-LAT-Port
64 Tunnel-Type
65 Tunnel-Medium-Type
66 Tunnel-Client-Endpt
67 Tunnel-Server-Endpt
68 Acct-Tunnel-Connection
75 Password-Retry
76 Prompt
77 Connect-Info
78 Configuration-Token
81 Tunnel-Pvt-Group-ID
82 Tunnel-Assignment-ID
83 Tunnel-Preference
85 Acct-Interim-Interval
107 Ascend-Calling-Subaddress
108 Ascend-Callback-Delay
109 Ascend-Endpoint-Disc
110 Ascend-Remote-FW
111 Ascend-Multicast-G-Leave-Delay
112 Ascend-CBCP-Enable
113 Ascend-CBCP-Mode
114 Ascend-CBCP-Delay
115 Ascend-CBCP-Trunk-Group
116 Ascend-Appletalk-Route
117 Ascend-Appletalk-Peer-Mode
118 Ascend-Route-Appletalk
119 Ascend-FCP-Parameter
120 Ascend-Modem-Port-No
121 Ascend-Modem-Slot-No
122 Ascend-Modem-Shelf-No
123 Ascend-CallAttempt-Limit
124 Ascend-CallBlock-Duration
125 Ascend-Maximum-Call-Duration
126 Ascend-Route-Preference
127 Ascend-Tunneling-Protocol
128 Ascend-Shared-Profile-Enable
129 Ascend-Primary-Home-Agent
130 Ascend-Secondary-Home-Agent
131 Ascend-Dialout-Allowed
132 Ascend-Client-Gateway
133 Ascend-BACP-Enable
134 Ascend-DHCP-Maximum-Leases
135 Ascend-Client-Primary-DNS
136 Ascend-Client-Secondary-DNS
137 Ascend-Client-Assign-DNS
138 Ascend-User-Acct-Type
139 Ascend-User-Acct-Host
140 Ascend-User-Acct-Port
141 Ascend-User-Acct-Key
142 Ascend-User-Acct-Base
143 Ascend-User-Acct-Time
144 Ascend-Assign-IP-Client
145 Ascend-Assign-IP-Server
146 Ascend-Assign-IP-Global-Pool
147 Ascend-DHCP-Reply
148 Ascend-DHCP-Pool-Number
149 Ascend-Expect-Callback
150 Ascend-Event-Type
151 Ascend-Session-Svr-Key
152 Ascend-Multicast-Rate-Limit
153 Ascend-IF-Netmask
154 Ascend-Remote-Addr
155 Ascend-Multicast-Client
156 Ascend-FR-Circuit-Name
157 Ascend-FR-Link-Up
158 Ascend-FR-Nailed-Grp
159 Ascend-FR-Type
160 Ascend-FR-Link-Mgt
161 Ascend-FR-N391
162 Ascend-FR-DCE-N392
163 Ascend-FR-DTE-N392
164 Ascend-FR-DCE-N393
165 Ascend-FR-DTE-N393
166 Ascend-FR-T391
167 Ascend-FR-T392
168 Ascend-Bridge-Address
169 Ascend-TS-Idle-Limit
170 Ascend-TS-Idle-Mode
171 Ascend-DBA-Monitor
172 Ascend-Base-Channel-Count
173 Ascend-Minimum-Channels
174 Ascend-IPX-Route
175 Ascend-FT1-Caller
176 Ascend-Backup
177 Ascend-Call-Type
178 Ascend-Group
179 Ascend-FR-DLCI
180 Ascend-FR-Profile-Name
181 Ascend-Ara-PW
182 Ascend-IPX-Node-Addr
183 Ascend-Home-Agent-IP-Addr
184 Ascend-Home-Agent-Password
185 Ascend-Home-Network-Name
186 Ascend-Home-Agent-UDP-Port
187 Ascend-Multilink-ID
188 Ascend-Num-In-Multilink
189 Ascend-First-Dest
190 Ascend-Pre-Input-Octets
191 Ascend-Pre-Output-Octets
192 Ascend-Pre-Input-Packets
193 Ascend-Pre-Output-Packets
194 Ascend-Maximum-Time
195 Ascend-Disconnect-Cause
196 Ascend-Connect-Progress
197 Ascend-Data-Rate
198 Ascend-Pre-Session-Time
199 Ascend-Token-Idle
200 Ascend-Token-Immediate
201 Ascend-Require-Auth
202 Ascend-Number-Sessions
203 Ascend-Authen-Alias
204 Ascend-Token-Expiry
205 Ascend-Menu-Selector
206 Ascend-Menu-Item
207 Ascend-PW-Warntime
208 Ascend-PW-Lifetime
209 Ascend-IP-Direct
210 Ascend-PPP-VJ-Slot-Comp
211 Ascend-PPP-VJ-1172
212 Ascend-PPP-Async-Map
213 Ascend-Third-Prompt
214 Ascend-Send-Secret
215 Ascend-Receive-Secret
216 Ascend-IPX-PeerMode
217 Ascend-IP-Pool-Definition
218 Ascend-Assign-IP-Pool
219 Ascend-FR-Direct
220 Ascend-FR-Direct-Profile
221 Ascend-FR-Direct-DLCI
222 Ascend-Handle-IPX
223 Ascend-Netware-Timeout
224 Ascend-IPX-Alias
225 Ascend-Metric
226 Ascend-PRI-Number-Type
227 Ascend-Dial-Number
228 Ascend-Route-IP
229 Ascend-Route-IPX
230 Ascend-Bridge
231 Ascend-Send-Auth
232 Ascend-Send-Passwd
233 Ascend-Link-Compression
234 Ascend-Target-Util
235 Ascend-Maximum-Channels
236 Ascend-Inc-Channel-Count
237 Ascend-Dec-Channel-Count
238 Ascend-Seconds-Of-History
239 Ascend-History-Weigh-Type
240 Ascend-Add-Seconds
241 Ascend-Remove-Seconds
242 Ascend-Data-Filter
243 Ascend-Call-Filter
244 Ascend-Idle-Limit
245 Ascend-Preempt-Limit
246 Ascend-Callback
247 Ascend-Data-Svc
248 Ascend-Force56
249 Ascend-Billing-Number
250 Ascend-Call-By-Call
251 Ascend-Transit-Number
252 Ascend-Host-Info
253 Ascend-PPP-Address
254 Ascend-MPP-Idle-Percent
255 Ascend-Xmit-Rate
4108 Client-IP-Address
4116 NAS-Manufacturer
4120 MS-CHAP-Domain
4121 MS-CHAP-Error
4127 Authentication-Type
4128 Client-Friendly-Name
4129 SAM-Account-Name
4130 Fully-Qualified-User-Name
4132 EAP-Friendly-Name
4134 MS-Acct-Auth-Type
4135 MS-Acct-EAP-Type
4136 Packet-Type
4142 Reason-Code
4143 MS-Filter
4147 MS-RAS-Vendor
4148 MS-RAS-Version
4149 NP-Policy-Name
4150 MS-Primary-DNS-Server
4151 MS-Secondary-DNS-Server
4152 MS-Primary-NBNS-Server
4153 MS-Secondary-NBNS-Server
5000 Cisco-AV-Pair
11000 USR-Last-Number-Dialed-Out
11001 USR-Last-Number-Dialed-In-DNIS
11002 USR-Last-Callers-Number-ANI
11003 USR-Channel
11004 USR-Event-Id
11005 USR-Event-Date-Time
11006 USR-Call-Start-Date-Time
11007 USR-Call-End-Date-Time
11008 USR-Default-DTE-Data-Rate
11009 USR-Initial-Rx-Link-Data-Rate
11010 USR-Final-Rx-Link-Data-Rate
11011 USR-Initial-Tx-Link-Data-Rate
11012 USR-Final-Tx-Link-Data-Rate
11013 USR-Chassis-Temperature
11014 USR-Chassis-Temp-Threshold
11015 USR-Actual-Voltage
11016 USR-Expected-Voltage
11017 USR-Power-Supply-Number
11018 USR-Card-Type
11019 USR-Chassis-Slot
11020 USR-Sync-Async-Mode
11021 USR-Originate-Answer-Mode
11022 USR-Modulation-Type
11023 USR-Initial-Modulation-Type
11024 USR-Connect-Term-Reason
11025 USR-Failure-to-Connect-Reason
11026 USR-Equalization-Type
11027 USR-Fallback-Enabled
11028 USR-Connect-Time-Limit
11029 USR-Number-of-Rings-Limit
11030 USR-DTE-Data-Idle-Timout
11031 USR-Characters-Sent
11032 USR-Characters-Received
11033 USR-Blocks-Sent
11034 USR-Blocks-Received
11035 USR-Blocks-Resent
11036 USR-Retrains-Requested
11037 USR-Retrains-Granted
11038 USR-Line-Reversals
11039 USR-Number-Of-Characters-Lost
11040 USR-Number-of-Blers
11041 USR-Number-of-Link-Timeouts
11042 USR-Number-of-Fallbacks
11043 USR-Number-of-Upshifts
11044 USR-Number-of-Link-NAKs
11045 USR-DTR-False-Timeout
11046 USR-Fallback-Limit
11047 USR-Block-Error-Count-Limit
11048 USR-DTR-True-Timeout
11049 USR-Security-Login-Limit
11050 USR-Security-Resp-Limit
11051 USR-DTE-Ring-No-Answer-Limit
11052 USR-Back-Channel-Data-Rate
11053 USR-Simplified-MNP-Levels
11054 USR-Simplified-V42bis-Usage
11055 USR-Mbi-Ct-PRI-Card-Slot
11056 USR-Mbi-Ct-TDM-Time-Slot
11057 USR-Mbi-Ct-PRI-Card-Span-Line
11058 USR-Mbi-Ct-BChannel-Used
11059 USR-Physical-State
11060 USR-Packet-Bus-Session
11061 USR-Server-Time
11062 USR-Channel-Connected-To
11063 USR-Slot-Connected-To
11064 USR-Device-Connected-To
11065 USR-NFAS-ID
11066 USR-Q931-Call-Reference-Value
11067 USR-Call-Event-Code
11068 USR-DS0
11069 USR-DS0s
11070 USR-Gateway-IP-Address
11071 USR-Call-Arrival-in-GMT
11072 USR-Call-Connect-in-GMT
11073 USR-Call-Terminate-in-GMT
11074 USR-IDS0-Call-Type
11075 USR-Call-Reference-Number
11076 USR-CDMA-Call-Reference-Number
11077 USR-Mobile-IP-Address
11078 USR-IWF-IP-Address
11079 USR-Called-Party-Number
11080 USR-Calling-Party-Number
11081 USR-Call-Type
11082 USR-ESN
11083 USR-IWF-Call-Identifier
11084 USR-IMSI
11085 USR-Service-Option
11086 USR-Disconnect-Cause-Indicator
11087 USR-Mobile-NumBytes-Txed
11088 USR-Mobile-NumBytes-Rxed
11089 USR-Num-Fax-Pages-Processed
11090 USR-Compression-Type
11091 USR-Call-Error-Code
11092 USR-Modem-Setup-Time
11093 USR-Call-Connecting-Time
11094 USR-Connect-Time
11095 USR-RMMIE-Manufacutere-ID
11096 USR-RMMIE-Product-Code
11097 USR-RMMIE-Serial-Number
11098 USR-RMMIE-Firmware-Version
11099 USR-RMMIE-Firmware-Build-Date
11100 USR-RMMIE-Status
11101 USR-RMMIE-Num-Of-Updates
11102 USR-RMMIE-x2-Status
11103 USR-RMMIE-Planned-Disconnect
11104 USR-RMMIE-Last-Update-Time
11105 USR-RMMIE-Last-Update-Event
11106 USR-RMMIE-Rcv-Tot-PwrLvl
11107 USR-RMMIE-Rcv-PwrLvl-3300Hz
11108 USR-RMMIE-Rcv-PwrLvl-3750Hz
11109 USR-RMMIE-PwrLvl-NearEcho-Canc
11110 USR-RMMIE-PwrLvl-FarEcho-Canc
11111 USR-RMMIE-PwrLvl-Noise-Lvl
11112 USR-RMMIE-PwrLvl-Xmit-Lvl
11113 USR-PW-IFilter-IP
11114 USR-PW-IFilter-IPX
11115 USR-PW-IFilter-SAP
11116 USR-PW-OFilter-IP
11117 USR-PW-OFilter-IPX
11118 USR-PW-OFilter-SAP
11119 USR-PW-VPN-ID
11120 USR-PW-VPN-Name
11121 USR-PW-VPN-Neighbor
11122 USR-PW-Framed-Routing-V2
11123 USR-PW-VPN-Gateway
11124 USR-PW-Tunnel-Authentication
11125 USR-PW-Index
11126 USR-PW-Cutoff
11127 USR-PW-Packet
11128 USR-Primary-DNS-Server
11129 USR-Secondary-DNS-Server
11130 USR-Primary-NBNS-Server
11131 USR-Secondary-NBNS-Server
11132 USR-Syslog-Tap
11133 USR-Log-Filter-Packet
11134 USR-Chassis-Call-Slot
11135 USR-Chassis-Call-Span
11136 USR-Chassis-Call-Channel
11137 USR-Keypress-Timeout
11138 USR-Unauthenticated-Time
11139 USR-VPN-Encryptor
11140 USR-VPN-GW-Location-Id
11141 USR-Re-Chap-Timeout
11142 USR-CCP-Algorithm
11143 USR-ACCM-Type
11144 USR-Connect-Speed
11145 USR-Framed-IP-Address-Pool-Name
11146 USR-MP-EDO
11147 USR-Local-Framed-IP-Addr
11148 USR-Framed-IPX-Route
11149 USR-MPIP-Tunnel-Originator
11150 USR-Bearer-Capabilities
11151 USR-Speed-Of-Connection
11152 USR-Max-Channels
11153 USR-Channel-Expansion
11154 USR-Channel-Decrement
11155 USR-Expansion-Algorithm
11156 USR-Compression-Algorithm
11157 USR-Receive-Acc-Map
11158 USR-Transmit-Acc-Map
11159 USR-Compression-Reset-Mode
11160 USR-Min-Compression-Size
11161 USR-IP
11162 USR-IPX
11163 USR-Filter-Zones
11164 USR-Appletalk
11165 USR-Bridging
11166 USR-Spoofing
11167 USR-Host-Type
11168 USR-Send-Name
11169 USR-Send-Password
11170 USR-Start-Time
11171 USR-End-Time
11172 USR-Send-Script1
11173 USR-Reply-Script1
11174 USR-Send-Script2
11175 USR-Reply-Script2
11176 USR-Send-Script3
11177 USR-Reply-Script3
11178 USR-Send-Script4
11179 USR-Reply-Script4
11180 USR-Send-Script5
11181 USR-Reply-Script5
11182 USR-Send-Script6
11183 USR-Reply-Script6
11184 USR-Terminal-Type
11185 USR-Appletalk-Network-Range
11186 USR-Local-IP-Address
11187 USR-Routing-Protocol
11188 USR-Modem-Group
11189 USR-IPX-Routing
11190 USR-IPX-WAN
11191 USR-IP-RIP-Policies
11192 USR-IP-RIP-Simple-Auth-Password
11193 USR-IP-RIP-Input-Filter
11194 USR-IP-Call-Input-Filter
11195 USR-IPX-RIP-Input-Filter
11196 USR-MP-MRRU
11197 USR-IPX-Call-Input-Filter
11198 USR-AT-Input-Filter
11199 USR-AT-RTMP-Input-Filter
11200 USR-AT-Zip-Input-Filter
11201 USR-AT-Call-Input-Filter
11202 USR-ET-Bridge-Input-Filter
11203 USR-IP-RIP-Output-Filter
11204 USR-IP-Call-Output-Filter
11205 USR-IPX-RIP-Output-Filter
11206 USR-IPX-Call-Output-Filter
11207 USR-AT-Output-Filter
11208 USR-AT-RTMP-Output-Filter
11209 USR-AT-Zip-Output-Filter
11210 USR-AT-Call-Output-Filter
11211 USR-ET-Bridge-Output-Filter
11212 USR-ET-Bridge-Call-Output-Filter
11213 USR-IP-Default-Route-Option
11214 USR-MP-EDO-HIPER
11215 USR-Modem-Training-Time
11216 USR-Interface-Index
11217 USR-Tunnel-Security
11218 USR-Port-Tap
11219 USR-Port-Tap-Format
11220 USR-Port-Tap-Output
11221 USR-Port-Tap-Facility
11222 USR-Port-Tap-Priority
11223 USR-Port-Tap-Address
11224 USR-MobileIP-Home-Agent-Address
11225 USR-Tunneled-MLPP
11226 USR-Multicast-Proxy
11227 USR-Multicast-Receive
11228 USR-Multicast-Forwarding
11229 USR-IGMP-Query-Interval
11230 USR-IGMP-Maximum-Response-Time
11231 USR-IGMP-Robustness
11232 USR-IGMP-Version
11233 USR-IGMP-Routing
11234 USR-VTS-Session-Key
11235 USR-Orig-NAS-Type
11236 USR-Call-Arrival-Time
11237 USR-Call-End-Time
11238 USR-Rad-Multicast-Routing-Ttl
11239 USR-Rad-Multicast-Routing-Rate-Limit
11240 USR-Rad-Multicast-Routing-Protocol
11241 USR-Rad-Multicast-Routing-Boundary
11242 USR-Rad-Dvmrp-Metric
11243 USR-Chat-Script-Name
11244 USR-Chat-Script-Rules
11245 USR-Rad-Location-Type
11246 USR-Tunnel-Switch-Endpoint
11247 USR-OSPF-Addressless-Index
11248 USR-Callback-Type
11249 USR-Tunnel-Auth-Hostname
11250 USR-Acct-Reason-Code
11251 USR-DNIS-ReAuthentication
11252 USR-PPP-Source-IP-Filter
11253 USR-Auth-Mode
11254 USR-NAS-Type
11255 USR-Request-Type
);

sub parse_ias {
  my $string = shift || return;
  return __PACKAGE__->new(@_)->parse($string);
}

sub new {
  my $package = shift;
  my %opts = @_;
  $opts{lc $_} = delete $opts{$_} for keys %opts;
  return bless \%opts, $package;
}

sub parse {
  my $self = shift;
  my $raw_line = shift || return;
  $raw_line =~ s/(\x0D\x0A?|\x0A\x0D?)$//;
  my @data = split /,/, $raw_line;
  return unless scalar @data >= 6;
  my @header = splice @data, 0, 6;
  my $record = { @data };
  foreach my $attribute ( keys %{ $record } ) {
    next unless exists $attributes{ $attribute };
    $record->{$attribute} = pack "H*", $record->{$attribute} if $record->{$attribute} =~ /^0x[0-9A-F]+$/i;
    $record->{$attribute} =~ s/[\x00-\x1F]//g;
    $record->{ $attributes{$attribute} } = delete $record->{$attribute};
  }
  @$record{qw/NAS-IP-Address User-Name Record-Date Record-Time Service-Name Computer-Name/} = @header;
  return $record;
}

1;
__END__

=head1 NAME

Parse::IASLog - A parser for Microsoft IAS-formatted log entries.

=head1 SYNOPSIS

Function Interface:

  use strict;
  use Data::Dumper;
  use Parse::IASLog;

  while (<>) {
	chomp;
	my $record = parse_ias( $_ );
	next unless $record;
	print Dumper( $record );
  }

Object Interface:

  use strict;
  use Data::Dumper;
  use Parse::IASLog;

  my $ias = Parse::IASLog->new();

  while (<>) {
	chomp;
	my $record = $ias->parse( $_ );
	next unless $record;
	print Dumper( $record );
  }

=head1 DESCRIPTION

Parse::IASLog provides a convenient way of parsing lines of text that are formatted in Microsoft
Internet Authentication Service (IAS) log format, where attributes are logged as attribute-value pairs.

The parser takes lines of IAS-formatted text and returns on successful parsing a hashref record containing
the applicable RADIUS attributes and values.

The module provides a perl implementation of the Iasparse tool.

=head1 FUNCTION INTERFACE

Using the module automagically imports 'parse_ias' into your namespace.

=over

=item parse_ias

Takes a string of IAS-formatted text. Returns a hashref on success or undef on failure.
See below for the format of the hashref returned.

=back

=head1 OBJECT INTERFACE

=head2 CONSTRUCTOR

=over 

=item new

Creates a new Parse::IASLog object.

=back

=head2 METHODS

=over 

=item parse

Takes a string of IAS-formatted text. Returns a hashref on success or undef on failure.

The hashref will contain RADIUS attributes as keys. The following 'header' attributes should always
be present:

  'NAS-IP-Address', The IP address of the NAS sending the request;
  'User-Name', The user name that is requesting access;
  'Record-Date', The date that the log was written;
  'Record-Time', The time that the log was written;
  'Service-Name', The name of the service that is running in the RADIUS server;
  'Computer-Name', The name of the RADIUS server;

=back

=head1 AUTHOR

Chris C<BinGOs> Williams <chris@bingosnet.co.uk>

=head1 SEE ALSO

L<http://technet.microsoft.com/en-us/network/bb643123.aspx>

L<http://en.wikipedia.org/wiki/RADIUS>