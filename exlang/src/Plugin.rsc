module Plugin

import util::IDE;
import ParseTree;
import IO;
import exlang::frontend::ExSyntax;

void main() {
   registerLanguage("ExLang", "ex", Tree(str src, loc l) {
     pt = parse(#start[CompilationUnit], src, l);
     return pt;
   });
}