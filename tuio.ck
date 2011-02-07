public class Tuio {
    // basic attributes
    int port;
    string hostName;
    OscRecv recv;
    
    int sessionID;
    int classID;
    float x; float y; float z;
    float a; float b; float c;
    float X; float Y; float Z;
    float A; float B; float C;
    float m; float r;
    
    
    
    // using a pre-constructor because ChucK doesn't support real constructors yet
    
    3333 => port;
    "localhost" => hostName;
    
    port => recv.port;
    recv.listen();
    
    // semantic types
    // s -> sessionID [int32]
    // i -> classID [int32]
    // x, y, z -> position, [float32, range 0 .. 1]
    // a, b, c -> angle, [float32, range 0 .. 2PI]
    // X, Y, Z -> movement vector (motion speed and direction), float32
    // A, B, C -> rotation vector (rotation speed and direction), float32
    // m -> motion acceleration, float32
    // r -> rotation acceleration, float32
    // P -> free parameter

    float cubos[50][10];
    
    // profiles
    // 2Dobj / 2Dcur
    // 25Dobj / 25Dcur
    // 3Dobj / 3Dcur
    // custom profile
    
    // /tuio/2Dobj set s i x y a X Y A m r
    // /tuio/2Dcur set s x y X Y m
    recv.event("/tuio/2Dobj,s,i,i,f,f,f,f,f,f,f,f") @=> OscEvent e2DObjSet;
    recv.event("/tuio/2Dcur,s,i,f,f,f,f,f") @=> OscEvent e2DCurSet;
    // /tuio/2Dobj alive [list of active sessionIDs]
    // /tuio/2Dobj fseq [int32]
    
    fun void update2DObj() {
        string format;
        while (true) {
            e2DObjSet => now;
            e2DObjSet.nextMsg();
            e2DObjSet.getString() => format;
            
            if (format == "set") {
                e2DObjSet.getInt() => sessionID;
                e2DObjSet.getInt() => classID;
                e2DObjSet.getFloat() => x;
                e2DObjSet.getFloat() => y;
                e2DObjSet.getFloat() => a;
                e2DObjSet.getFloat() => X;
                e2DObjSet.getFloat() => Y;
                e2DObjSet.getFloat() => A;
                e2DObjSet.getFloat() => m;
                e2DObjSet.getFloat() => r;
            } else if (format == "alive") {
                <<< "alive!" >>>;
            }
        }
    }
    
    fun void updateCubos() {
        string format;
        while (true) {
            e2DObjSet => now;
            e2DObjSet.nextMsg();
            e2DObjSet.getString() => format;
            
            if (format == "set") {
                int c;
                int s;
                e2DObjSet.getInt() => s;
                e2DObjSet.getInt() => c;
                c => cubos[c][0];
                s => cubos[c][1];
                e2DObjSet.getFloat() => cubos[c][2];
                e2DObjSet.getFloat() => cubos[c][3];
                e2DObjSet.getFloat() => cubos[c][4];
                e2DObjSet.getFloat() => cubos[c][5];
                e2DObjSet.getFloat() => cubos[c][6];
                e2DObjSet.getFloat() => cubos[c][7];
                e2DObjSet.getFloat() => cubos[c][8];
                e2DObjSet.getFloat() => cubos[c][9];
            } else if (format == "alive") {
                <<< "alive!" >>>;
            }
        }
    }
    
    
    fun void start() {
        for (0 => int i; i<50; i++) {
            for (0 => int j; j<10; j++) {
                0.0 => cubos[i][j];
            }
        }
        
        spork ~ updateCubos();
    }
}