(

Task {
	var myname = 'abc'; 
	"\n\n *** Republic - startup file for %.\n".postf(myname); 
	
	r = Republic.default ?? { Republic.new.makeDefault };
	z = RepublicGui(r); // add a display if you like.
	z.switchSize(1);	// hide chat area
	r.shareHistory; 
	AllGui.new;		// global overview
	PdefAllGui(12);
	TdefAllGui(12);
	
	Server.all.do { |sv| try { sv.window.close } };

			// server setup - reserve busses for shared audio and control signals
	r.options
		.numInputBusChannels_(8)
		.numOutputBusChannels_(8)
		.numReservedControlBuses_(32) 	// for shared control busses
		.numReservedAudioBuses_(16); 		// for combined playing
	
			// joining creates the server as well
	r.join(myname);

		// wait until server is there
	0.5.wait; 
		
		// make it the default server for easier testing
	Server.default = r.myServer;
	
		// share a synthdef for testing
	SynthDef(\xxy, {|out, sustain = 1, freq = 440|
		var env = Line.kr(0.1, 0, sustain, doneAction: 2);
		var son = SinOsc.ar(freq * [1, 1.2, 1.5, 1.7]).sum;
		Out.ar(out, son * env);
	}).share;

		// shared synthdefs would typically be in one big file, and loaded with 
// 	"~/whatever/folder/allMyRepublicSynthDefs.scd".load; 
	
		// and probably open a file with some starting events, patterns, etc:
	Document.open(
		Republic.filenameSymbol.asString.dirname.dirname 
		+/+ "republic_basicpatterns.scd"
	);
	
		// customize post window
	Document.listener
		.bounds_(Rect(450, 2, 600, 200))
		.background_(Color.blue(0.2))
		.stringColor_(Color.yellow);
	Document.postColor_(Color.yellow);
		
		
	"\n*** Republic - startup file for % loaded fine.\n\n\n".postf(myname); 
	
}.play(AppClock);
);