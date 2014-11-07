#include "fstream"
#include "ostream"

#include <maapi.h>
#include <mavsprintf.h>
#include <MAUtil/Environment.h>
#include <MAUtil/Moblet.h>
#include <MAUI/Screen.h>
#include <MAUI/Label.h>
#include <MAUI/RelativeLayout.h>
#include <MAUI/Style.h>
#include <MAUI/Button.h>
#include <MAUI/Engine.h>

using namespace std;

class MyApp
		: public MAUtil::Moblet
		//, public MAUI::Engine
		, public MAUI::Screen
		, public MAUI::ButtonListener
  {
public:
	MyApp()
		: MAUtil::Moblet()
	//	, m_engine(MAUI::Engine::getSingleton())
	{


		m_widget = new MAUI::RelativeLayout(0,0,EXTENT_X(maGetScrSize()),EXTENT_Y(maGetScrSize()));
		m_title = new MAUI::Label(0,0,200,50,"Title");
		//m_title->setStyle()
		m_widget->add(m_title);
		m_button = new MAUI::Button(0,50,200,50,"Click me!");
		m_button->addButtonListener(this);
		m_widget->add(m_button);;

	setMain(m_widget);
		show();

	}
	void onButtonEvent(MAUI::Button* button, bool pressed) {
	//	hide();
		m_title->setCaption("button");
		MAUI::Engine::getSingleton().repaint();

//		show();
	}

private:
	//MAUI::Engine& m_engine;

	MAUI::Label* m_title;
	MAUI::RelativeLayout* m_widget;
	MAUI::Button* m_button;
};

extern "C"
int MAMain() {

  string s = "blah";
  

  //MAUtil::Environment &env = MAUtil::Environment::getEnvironment();
  MyApp moblet;

  MAUtil::Moblet::run(&moblet);

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
