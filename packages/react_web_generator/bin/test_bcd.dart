import 'package:react_web_generator/src/bcd_filter.dart';

void main() {
  try {
    final filter = BcdFilter.load();
    print('BCD filter loaded successfully');
    print('XRAnchor shouldGenerate: ${filter.shouldGenerateInterface("XRAnchor")}');
    print('XRAnchor isFilteredOut: ${filter.isFilteredOutInterface("XRAnchor")}');
    print('XRCPUDepthInformation shouldGenerate: ${filter.shouldGenerateInterface("XRCPUDepthInformation")}');
    print('XRCPUDepthInformation isFilteredOut: ${filter.isFilteredOutInterface("XRCPUDepthInformation")}');
  } catch (e) {
    print('Error loading BCD filter: $e');
  }
}
