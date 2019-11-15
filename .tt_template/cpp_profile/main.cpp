#include <iostream>
#include <string>
#include <vector>
#include <list>
#include <map>
#include <algorithm>
#include <iomanip>
#include <ratio>
#include "timer.h"

int main(int argc, char *argv[])
{
  Timer timer;
  timer.reset();

  for (unsigned i = 0; i < 10000000; ++i)
  {
    std::string s("aaaaaaaaaaaaaaaaaaaa");
  }

  std::cout << timer.milliseconds().count() << std::endl;


}
