%%%----------------------------------------------------------------------
%%% Copyright (c) 2008-2012 Peter Lemenkov <lemenkov@gmail.com>
%%%
%%% All rights reserved.
%%%
%%% Redistribution and use in source and binary forms, with or without modification,
%%% are permitted provided that the following conditions are met:
%%%
%%% * Redistributions of source code must retain the above copyright notice, this
%%% list of conditions and the following disclaimer.
%%% * Redistributions in binary form must reproduce the above copyright notice,
%%% this list of conditions and the following disclaimer in the documentation
%%% and/or other materials provided with the distribution.
%%% * Neither the name of the authors nor the names of its contributors
%%% may be used to endorse or promote products derived from this software
%%% without specific prior written permission.
%%%
%%% THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
%%% EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
%%% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
%%% DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
%%% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
%%% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
%%% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
%%% ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
%%% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
%%% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%%%
%%%----------------------------------------------------------------------

-module(zrtp_complex_test).

-include("zrtp.hrl").
-include_lib("eunit/include/eunit.hrl").

zrtp_complex_test_() ->
	ZrtpMarker = <<16,0>>, % 16#1000
	MagicCookie = <<"ZRTP">>,

	% Hash vectors
	H1 = <<152,154,62,17,91,59,159,56,94,85,78,21,208,79,160,223,4,98,78,102,241,157,227,166,215,133,35,99,115,241,252,34>>,
	H2 = <<30,245,116,43,215,16,39,7,110,252,252,176,151,231,112,74,81,230,239,191,27,210,241,137,170,241,115,159,54,127,146,20>>,
	H3 = <<129,243,142,173,184,37,87,24,183,74,187,211,153,46,93,116,222,159,1,129,229,255,105,246,99,135,100,83,62,176,235,74>>,

	% HELLO data

	HelloSequence = <<0,1>>, % 1
	HelloSSRC = <<131,2,99,21>>,
	HelloPayload = <<80,90,0,29,72,101,108,108,111,32,32,32,49,46,49,48,71,
	78,85,32,90,82,84,80,52,74,32,50,46,49,46,48,129,243,142,173,184,37,87,
	24,183,74,187,211,153,46,93,116,222,159,1,129,229,255,105,246,99,135,
	100,83,62,176,235,74,12,18,241,209,181,195,98,133,85,240,101,201,0,1,18,
	33,83,50,53,54,65,69,83,49,72,83,51,50,72,83,56,48,68,72,51,107,77,117,
	108,116,66,51,50,32,206,91,237,147,204,255,184,239>>,
	HelloCRC = <<55,82,152,18>>,
	HelloZrtpBin = <<ZrtpMarker/binary, HelloSequence/binary, MagicCookie/binary, HelloSSRC/binary, HelloPayload/binary, HelloCRC/binary>>,

	HelloMessage = #hello{
		clientid = <<"GNU ZRTP4J 2.1.0">>,
		h3 = H3,
		zid = <<12,18,241,209,181,195,98,133,85,240,101,201>>,
		s = 0,
		m = 0,
		p = 0,
		hash = [<<"S256">>],
		cipher = [<<"AES1">>],
		auth = [<<"HS32">>,<<"HS80">>],
		keyagr = [<<"DH3k">>,<<"Mult">>],
		sas = [<<"B32 ">>],
		mac = <<206,91,237,147,204,255,184,239>>
	},
	HelloZrtp = #zrtp{sequence = 1, ssrc = 2197971733, message = HelloMessage},

	% COMMIT data

	CommitSequence = <<0,3>>, % 3
	CommitSSRC = <<131,2,99,21>>,
	CommitPayload = <<80,90,0,29,67,111,109,109,105,116,32,32,30,245,116,43,
	215,16,39,7,110,252,252,176,151,231,112,74,81,230,239,191,27,210,241,
	137,170,241,115,159,54,127,146,20,12,18,241,209,181,195,98,133,85,240,
	101,201,83,50,53,54,65,69,83,49,72,83,51,50,68,72,51,107,66,51,50,32,47,
	192,193,234,25,118,126,42,0,241,125,53,60,122,157,5,211,171,245,63,113,
	147,58,107,12,143,154,68,86,117,187,40,25,0,51,120,101,107,177,124>>,
	CommitCRC = <<166,61,245,82>>,
	CommitZrtpBin = <<ZrtpMarker/binary, CommitSequence/binary, MagicCookie/binary, CommitSSRC/binary, CommitPayload/binary, CommitCRC/binary>>,

	CommitMessage = #commit{
		h2 = H2,
		zid = <<12,18,241,209,181,195,98,133,85,240,101,201>>,
		hash = <<"S256">>,
		cipher = <<"AES1">>,
		auth = <<"HS32">>,
		keyagr = <<"DH3k">>,
		sas = <<"B32 ">>,
		hvi = <<47,192,193,234,25,118,126,42,0,241,125,53,60,122,157,5,211,171,245,63,113,147,58,107,12,143,154,68,86,117,187,40>>,
		nonce = null,
		keyid = null,
		mac = <<25,0,51,120,101,107,177,124>>
	},
	CommitZrtp = #zrtp{sequence = 3, ssrc = 2197971733, message = CommitMessage},

	% DHPART1 data

	Dhpart1Sequence = <<0,4>>, % 4
	Dhpart1SSRC = <<131,2,99,21>>,
	Dhpart1Payload = <<80,90,0,117,68,72,80,97,114,116,49,32,152,154,62,17,
	91,59,159,56,94,85,78,21,208,79,160,223,4,98,78,102,241,157,227,166,215,
	133,35,99,115,241,252,34,215,185,25,48,117,116,71,135,42,250,167,106,
	252,240,36,102,32,157,88,186,193,118,143,181,120,202,237,239,152,31,168,
	188,51,28,210,248,155,9,96,96,53,139,185,169,116,164,82,161,35,76,129,
	197,68,142,64,101,89,165,179,192,26,206,151,32,130,142,243,234,187,123,
	188,3,124,10,24,248,98,115,160,140,58,93,117,137,230,77,202,52,218,218,
	224,5,97,227,23,3,168,104,196,130,3,146,243,252,59,184,103,171,254,234,
	149,248,158,89,23,5,25,63,195,138,77,168,192,129,179,83,111,255,28,255,
	82,151,52,25,27,36,236,46,13,143,196,9,178,206,181,251,52,14,141,7,28,
	29,91,219,218,218,111,78,186,27,8,30,150,73,5,194,23,108,136,98,21,193,
	27,24,141,212,160,79,21,228,13,60,40,158,155,147,147,98,191,73,243,171,
	109,108,210,52,44,12,106,147,83,189,227,121,97,129,231,35,135,234,58,
	213,95,136,39,134,54,72,101,123,117,104,144,101,71,196,187,171,159,191,
	104,193,130,170,47,203,132,66,109,75,233,29,146,58,61,77,2,139,118,38,
	154,61,54,125,45,108,160,125,18,235,175,116,177,82,145,119,78,172,64,
	166,199,237,253,105,234,237,137,10,143,125,238,68,56,128,14,245,2,79,1,
	161,152,131,128,181,250,218,95,19,196,231,98,41,8,69,115,215,91,212,249,
	238,122,86,242,153,84,141,241,82,138,110,153,187,163,228,9,116,228,47,
	53,113,145,110,47,193,11,66,186,179,135,177,192,124,58,249,107,59,115,
	104,76,136,164,25,20,78,246,22,60,166,7,124,64,44,16,34,69,32,42,120,
	244,214,117,120,129,174,87,92,229,69,225,40,22,159,84,43,2,173,85,194,
	107,0,194,88,134,26,84,141,19,203,125,228,183,138,25,246,233,212,9,8,
	127,217,180,230,31,183,135,17,197,175,0,22,38,238,34,55>>,
	Dhpart1CRC = <<7,55,38,47>>,
	Dhpart1ZrtpBin = <<ZrtpMarker/binary, Dhpart1Sequence/binary, MagicCookie/binary, Dhpart1SSRC/binary, Dhpart1Payload/binary, Dhpart1CRC/binary>>,

	Dhpart1Message = #dhpart1{
		h1 = H1,
		rs1IDr = <<215,185,25,48,117,116,71,135>>,
		rs2IDr = <<42,250,167,106,252,240,36,102>>,
		auxsecretIDr = <<32,157,88,186,193,118,143,181>>,
		pbxsecretIDr = <<120,202,237,239,152,31,168,188>>,
		pvr = <<51,28,210,248,155,9,96,96,53,139,185,169,116,164,82,161,
		35,76,129,197,68,142,64,101,89,165,179,192,26,206,151,32,130,
		142,243,234,187,123,188,3,124,10,24,248,98,115,160,140,58,93,
		117,137,230,77,202,52,218,218,224,5,97,227,23,3,168,104,196,130,
		3,146,243,252,59,184,103,171,254,234,149,248,158,89,23,5,25,63,
		195,138,77,168,192,129,179,83,111,255,28,255,82,151,52,25,27,36,
		236,46,13,143,196,9,178,206,181,251,52,14,141,7,28,29,91,219,
		218,218,111,78,186,27,8,30,150,73,5,194,23,108,136,98,21,193,27,
		24,141,212,160,79,21,228,13,60,40,158,155,147,147,98,191,73,243,
		171,109,108,210,52,44,12,106,147,83,189,227,121,97,129,231,35,
		135,234,58,213,95,136,39,134,54,72,101,123,117,104,144,101,71,
		196,187,171,159,191,104,193,130,170,47,203,132,66,109,75,233,29,
		146,58,61,77,2,139,118,38,154,61,54,125,45,108,160,125,18,235,
		175,116,177,82,145,119,78,172,64,166,199,237,253,105,234,237,
		137,10,143,125,238,68,56,128,14,245,2,79,1,161,152,131,128,181,
		250,218,95,19,196,231,98,41,8,69,115,215,91,212,249,238,122,86,
		242,153,84,141,241,82,138,110,153,187,163,228,9,116,228,47,53,
		113,145,110,47,193,11,66,186,179,135,177,192,124,58,249,107,59,
		115,104,76,136,164,25,20,78,246,22,60,166,7,124,64,44,16,34,69,
		32,42,120,244,214,117,120,129,174,87,92,229,69,225,40,22,159,84,
		43,2,173,85,194,107,0,194,88,134,26,84,141,19,203,125,228,183,
		138,25,246,233,212,9,8,127,217,180,230,31,183,135,17>>,
		mac = <<197,175,0,22,38,238,34,55>>
	},
	Dhpart1Zrtp = #zrtp{sequence = 4, ssrc = 2197971733, message = Dhpart1Message},

	% DHPART2 data

	Dhpart2Sequence = <<0,4>>, % 4
	Dhpart2SSRC = <<131,2,101,199>>,
	Dhpart2Payload = <<80,90,0,117,68,72,80,97,114,116,50,32,50,11,151,90,
	234,110,70,186,161,209,67,93,197,140,2,30,65,221,70,65,130,98,118,42,
	132,229,100,162,236,93,114,241,22,38,97,78,137,5,28,82,237,173,46,63,
	159,117,201,77,8,33,19,160,92,32,19,238,81,81,204,168,177,80,21,72,51,
	136,103,93,43,31,149,20,162,217,218,62,88,101,149,229,173,75,10,209,64,
	209,207,170,156,99,3,21,251,52,93,134,150,125,85,30,94,181,245,212,235,
	9,21,56,248,90,122,101,76,27,255,207,88,196,56,184,22,17,120,147,60,236,
	255,55,18,184,246,254,98,201,146,93,78,8,119,140,104,67,44,156,224,223,
	59,158,104,143,109,150,177,192,206,48,190,71,213,116,222,113,226,222,
	235,227,200,9,234,196,111,7,30,130,234,70,194,255,224,44,143,61,55,121,
	82,127,241,231,111,146,51,118,23,138,153,19,200,243,91,137,73,167,84,33,
	239,78,122,240,86,14,29,59,86,70,209,177,245,64,10,73,129,179,255,90,13,
	200,177,101,97,60,250,238,31,163,110,232,199,87,218,223,146,74,221,246,
	208,135,77,79,162,102,96,81,248,19,126,23,245,233,122,131,183,74,218,
	200,138,16,144,223,246,109,215,165,53,62,115,244,92,206,83,27,120,195,
	231,68,241,45,37,85,91,51,170,99,142,174,6,130,209,109,104,202,38,116,
	214,105,20,113,26,32,96,207,147,180,70,142,247,103,101,240,61,223,35,69,
	25,123,22,132,104,245,186,58,51,200,193,233,160,230,143,22,150,136,196,
	55,194,184,205,24,88,146,251,116,163,191,28,169,73,111,165,235,253,58,
	235,102,29,238,254,227,151,130,205,135,227,164,169,64,121,7,8,3,225,207,
	160,8,210,243,131,164,163,172,2,132,155,199,224,253,238,51,167,54,214,
	150,146,31,122,33,93,130,211,53,7,212,80,199,214,234,199,150,34,132,61,
	88,63,225,175,135,214,61,6,58,213,174,26,236,27,74,69,23,231,249,124,
	130,127,134,235,175,26,109,81,82,136,186,70,225,126,85,81,75>>,
	Dhpart2CRC = <<198,17,69,244>>,
	Dhpart2ZrtpBin = <<ZrtpMarker/binary, Dhpart2Sequence/binary, MagicCookie/binary, Dhpart2SSRC/binary, Dhpart2Payload/binary, Dhpart2CRC/binary>>,

	Dhpart2Message = #dhpart2{
		h1 = <<50,11,151,90,234,110,70,186,161,209,67,93,197,140,2,30,65,221,70,65,130,98,118,42,132,229,100,162,236,93,114,241>>,
		rs1IDi = <<22,38,97,78,137,5,28,82>>,
		rs2IDi = <<237,173,46,63,159,117,201,77>>,
		auxsecretIDi = <<8,33,19,160,92,32,19,238>>,
		pbxsecretIDi = <<81,81,204,168,177,80,21,72>>,
		pvi = <<51,136,103,93,43,31,149,20,162,217,218,62,88,101,149,
		229,173,75,10,209,64,209,207,170,156,99,3,21,251,52,93,134,150,
		125,85,30,94,181,245,212,235,9,21,56,248,90,122,101,76,27,255,
		207,88,196,56,184,22,17,120,147,60,236,255,55,18,184,246,254,98,
		201,146,93,78,8,119,140,104,67,44,156,224,223,59,158,104,143,
		109,150,177,192,206,48,190,71,213,116,222,113,226,222,235,227,
		200,9,234,196,111,7,30,130,234,70,194,255,224,44,143,61,55,121,
		82,127,241,231,111,146,51,118,23,138,153,19,200,243,91,137,73,
		167,84,33,239,78,122,240,86,14,29,59,86,70,209,177,245,64,10,73,
		129,179,255,90,13,200,177,101,97,60,250,238,31,163,110,232,199,
		87,218,223,146,74,221,246,208,135,77,79,162,102,96,81,248,19,
		126,23,245,233,122,131,183,74,218,200,138,16,144,223,246,109,
		215,165,53,62,115,244,92,206,83,27,120,195,231,68,241,45,37,85,
		91,51,170,99,142,174,6,130,209,109,104,202,38,116,214,105,20,
		113,26,32,96,207,147,180,70,142,247,103,101,240,61,223,35,69,25,
		123,22,132,104,245,186,58,51,200,193,233,160,230,143,22,150,136,
		196,55,194,184,205,24,88,146,251,116,163,191,28,169,73,111,165,
		235,253,58,235,102,29,238,254,227,151,130,205,135,227,164,169,
		64,121,7,8,3,225,207,160,8,210,243,131,164,163,172,2,132,155,
		199,224,253,238,51,167,54,214,150,146,31,122,33,93,130,211,53,7,
		212,80,199,214,234,199,150,34,132,61,88,63,225,175,135,214,61,6,
		58,213,174,26,236,27,74,69,23,231,249,124,130,127,134,235,175,
		26,109,81,82>>,
		mac = <<136,186,70,225,126,85,81,75>>
	},
	Dhpart2Zrtp = #zrtp{sequence = 4, ssrc = 2197972423, message = Dhpart2Message},

	% CONFIRM1 data

	Confirm1Sequence = <<0,5>>, % 5
	Confirm1SSRC = <<131,2,99,21>>,
	Confirm1Payload = <<80,90,0,19,67,111,110,102,105,114,109,49,148,85,245,187,36,114,4,245,27,255,83,15,219,187,180,150,86,252,19,114,15,137,228,193,42,194,141,49,6,235,134,46,114,51,142,61,187,35,120,228,210,137,88,52,234,86,24,37,117,95,151,114,171,242,12,246,82,13,76,137,3,214,248,95>>,
	Confirm1CRC = <<132,175,88,228>>,
	Confirm1ZrtpBin = <<ZrtpMarker/binary, Confirm1Sequence/binary, MagicCookie/binary, Confirm1SSRC/binary, Confirm1Payload/binary, Confirm1CRC/binary>>,

	Confirm1Message = #confirm1{
		conf_mac = <<148,85,245,187,36,114,4,245>>,
		cfb_init_vect = <<27,255,83,15,219,187,180,150,86,252,19,114,15,137,228,193>>,
		encrypted_data = <<42,194,141,49,6,235,134,46,114,51,142,61,187,35,120,228,210,137,88,52,234,86,24,37,117,95,151,114,171,242,12,246,82,13,76,137,3,214,248,95>>
	},
	Confirm1Zrtp = #zrtp{sequence = 5, ssrc = 2197971733, message = Confirm1Message},

	% CONFIRM2 data

	Confirm2Sequence = <<0,6>>, % 6
	Confirm2SSRC = <<131,2,101,199>>,
	Confirm2Payload = <<80,90,0,19,67,111,110,102,105,114,109,50,95,83,113,139,2,137,182,18,53,173,132,163,54,242,8,67,121,214,111,240,123,173,98,11,142,95,80,208,153,237,44,214,178,197,229,68,11,94,180,90,85,37,111,89,49,251,49,205,226,140,255,21,125,202,10,79,26,186,235,83,212,38,26,164>>,
	Confirm2CRC = <<170,213,207,247>>,
	Confirm2ZrtpBin = <<ZrtpMarker/binary, Confirm2Sequence/binary, MagicCookie/binary, Confirm2SSRC/binary, Confirm2Payload/binary, Confirm2CRC/binary>>,

	Confirm2Message = #confirm2{
		conf_mac = <<95,83,113,139,2,137,182,18>>,
		cfb_init_vect = <<53,173,132,163,54,242,8,67,121,214,111,240,123,173,98,11>>,
		encrypted_data = <<142,95,80,208,153,237,44,214,178,197,229,68,11,94,180,90,85,37,111,89,49,251,49,205,226,140,255,21,125,202,10,79,26,186,235,83,212,38,26,164>>
	},
	Confirm2Zrtp = #zrtp{sequence = 6, ssrc = 2197972423, message = Confirm2Message},

	% tests

	[
		%%
		%% Complex ZRTP processing
		%%

		{"Check that we can confirm HELLO message integrity based on H2",
			fun() -> ?assertEqual(true, zrtp:verify_hmac(HelloZrtp, H2)) end
		},
		{"Check that we can confirm COMMIT message integrity based on H1",
			fun() -> ?assertEqual(true, zrtp:verify_hmac(CommitZrtp, H1)) end
		},
		{"Check that we CAN NOT confirm DHPart1 message integrity based on Confirm1's H0 (cannot decode it)",
			fun() -> ?assertEqual(false, zrtp:verify_hmac(Confirm1Zrtp, null)) end
		},
		{"Compute hvi which will be used within COMMIT message",
			fun() -> ?assertEqual(
						<<242,55,250,2,221,114,157,202,156,228,230,90,51,114,23,186,61,89,18,56,103,208,18,71,151,190,133,160,97,87,178,186>>,
						zrtp:calculate_hvi(HelloMessage, Dhpart2Message, fun hmac:hmac256/2)
					) end
		}
	].
