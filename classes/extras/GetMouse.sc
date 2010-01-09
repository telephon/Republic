GetMouseX {
	var <>minval=0, <>maxval=1, <warp=0, <lag=0.2, <>server;
	var <>action;
	var <value;
	var synth, resp;
	
	*new { |minval=0, maxval=1, warp=0, lag=0.2, server|
		^super.newCopyArgs(minval, maxval, warp, lag, server ? Server.default).run
	}
	
	run {
		var cmd = '/' ++ this.mouseClass.name ++ this.identityHash.abs;
		value = minval;
		if(server.serverRunning.not) { "server % not running".format(server.name).warn; ^this };
		server.sendBundle(nil, ['/error', -1],['/notify', 1],['/error', -2]);
		synth = { |updateRate = 5|
			var mouse = this.mouseClass.kr(minval, maxval, warp, lag);
			var change = HPZ2.kr(mouse) > 0;
			SendReply.kr(
						Impulse.kr(updateRate) * change + Impulse.kr(0), 
						cmd, 
						mouse
					);
		}.play(server);
		synth.register;
		synth.addDependant(this);
		resp = OSCresponder(server.addr, cmd, { |t,r,msg| 
			value = msg[3];
			action.value(value);
		});
		resp.add;
		CmdPeriod.add(this);
		
	
	}
	
	rate_ { |rate|
		synth.set(\updateRate, rate)
	}
	
	cmdPeriod { this.stop; CmdPeriod.remove(this) }
	
	stop { resp !? { resp.remove }; synth.removeDependant(this); synth.free;  }
		
	mouseClass {
		^MouseX
	}
	
	update { |who, what|
		if(what == \n_end) { this.run };
	}
}

GetMouseY : GetMouseX {
	mouseClass {
		^MouseY
	}
}