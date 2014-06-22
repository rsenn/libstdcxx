#include "fstream"
#include "ostream"

#include <maapi.h>
#include <mavsprintf.h>

using namespace std;

extern "C"
int MAMain() {

	string s = "blah";

	lprintfln("test: %s", s.c_str());

  return 0;
  
  MAEvent ev;
  
  while(maGetEvent(&ev) == 0) {

  }
  return 0;
}
