import std.stdio : writefln, stderr;
import std.digest.sha : sha256Of;
import std.digest.toHex; // pour toHexString
import std.algorithm.sorting : sort;
import std.file : read, exists;
import std.algorithm : map;
import std.array : array;
import std.string : startsWith;

void main(string[] args)
{
    if (args.length < 2) {
        stderr.writefln("Usage:\n  %s -s <file1> <file2> ...\n  %s <file1> <file2> ...", args[0], args[0]);
        return;
    }

    if (args[1].startsWith("-")) {
        string mode = args[1];
        auto files = args[2..$];

        foreach (f; files) {
            if (!exists(f)) {
                stderr.writefln("Erreur : le fichier \"%s\" n'existe pas.", f);
                return;
            }
        }

        // Mode -s : tri des hashes
        if (mode == "-s") {
            auto hashes = files.map!(f => sha256Of(read(f)).toHexString()).array;
            auto sortedHashes = sort(hashes);
            foreach (hash; sortedHashes) {
                writefln("%s", hash);
            }
        } else {
            stderr.writefln("Option inconnue : %s", mode);
        }

    } else {
        // Pas de flag : on hash les fichiers et affiche "salut : <hash>"
        auto files = args[1..$];
        foreach (f; files) {
            if (!exists(f)) {
                stderr.writefln("Erreur : le fichier \"%s\" n'existe pas.", f);
                return;
            }
            auto hash = sha256Of(read(f)).toHexString();
            writefln("salut : %s", hash);
        }
    }
}
