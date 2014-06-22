#include "fstream"
#include "ostream"

#include <maapi.h>
#include <mavsprintf.h>

using namespace std;

extern "C"
int MAMain() {

  string s = "blah";

  return 0;
  

  MAEvent ev;
  
  for(;;) {
		while(maGetEvent(&ev) == 0) {

		}
		maWait(1000);
	  lprintfln("test: %s", s.c_str());
  }

  return 0;
}
