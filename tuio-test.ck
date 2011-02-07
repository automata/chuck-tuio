Tuio tuio;

tuio.start();

spork ~ um();
spork ~ dois();

<<< "oi" >>>;

while (true) {
    
    1::second => now;
}

fun void um() {
    SinOsc s => dac;

while (true) {
    <<< "Cubo 0: ", tuio.cubos[0][3]*100, tuio.cubos[0][2]*10 >>>;
    s.gain(tuio.cubos[0][3]*100);
    s.freq(tuio.cubos[0][2]*1000);
    
    1000::ms => now;
}
}

fun void dois() {
    SinOsc s => dac;

while (true) {
    <<< "Cubo 1: ", tuio.cubos[1][3]*100, tuio.cubos[1][2]*10 >>>;
    s.gain(tuio.cubos[1][3]*100);
    s.freq(tuio.cubos[1][2]*1000);
    
    1000::ms => now;
}
}

