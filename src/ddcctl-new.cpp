

#include "DDC.h"
#include <cxxopts.hpp>
#include <algorithm>
#include <map>
#include <vector>
#include <string>


using std::pair;
using std::make_pair;
using std::vector;
using std::string;
using std::map;

using DDCAction = std::pair<int,int>;
using Display = DisplayInfo;
using Displays = vector<Display>;

/**
 * Execute a ddc action
 * on a `std::vector<DisplayInfo>`
 *
 * @param displays
 * @param action
 */
static void executeDDCAction(const Displays & displays, const DDCAction & action) {

    for (const auto & display : displays) {
      struct DDCWriteCommand command {
        static_cast<UInt8>(action.first),
        static_cast<UInt8>(action.second)
      };

      printf("D: setting VCP control #%u => %u\n", command.control_id, command.new_value);

      if (!DDCWrite(display, &command)) {
        printf("E: Failed to send DDC command!\n");
      }
    }
}

int main(int argc, char **argv) {
  auto allDisplays = getDisplays();
  auto displays = getDisplays();

  vector<DDCAction> actions;

  cxxopts::Options options("ddcctl", "DDC/CI Monitor Control");
  options.add_options("common")
    ("d," DISPLAY_OPT, "Display number", cxxopts::value<int>()->default_value("-1"))
    ("b," BRIGHTNESS_OPT, "Display number", cxxopts::value<int>());

  options.help();
  auto opts = options.parse(argc, argv);

  auto index = opts["display"].as<int>();
  if (index > -1) {
    displays.clear();
    displays.push_back(allDisplays[index]);
  }


  if (opts.count("brightness")) {
    actions.emplace_back(BRIGHTNESS, opts["brightness"].as<int>());
//    auto brightness = ;

  }
  for (const auto &info : displays) {
    printf("Screen #%u: %s\n", info.index, info.name.data());


  }

  for (const auto & action : actions) {
    executeDDCAction(displays, action);
  }





  return 0;
}