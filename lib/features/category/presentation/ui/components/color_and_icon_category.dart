import 'package:finan_master_app/shared/presentation/mixins/theme_context.dart';
import 'package:finan_master_app/shared/presentation/ui/components/draggable_bottom_sheet.dart';
import 'package:finan_master_app/shared/presentation/ui/components/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ColorAndIconCategory extends StatefulWidget {
  final Color? color;
  final IconData? icon;

  const ColorAndIconCategory({Key? key, this.color, this.icon}) : super(key: key);

  @override
  State<ColorAndIconCategory> createState() => _ColorAndIconCategoryState();

  static Future<({Color color, IconData icon})?> show({required BuildContext context, Color? color, IconData? icon}) async {
    return await showModalBottomSheet<({Color color, IconData icon})>(
      context: context,
      showDragHandle: true,
      enableDrag: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => ColorAndIconCategory(color: color, icon: icon),
    );
  }
}

class _ColorAndIconCategoryState extends State<ColorAndIconCategory> with ThemeContext {
  Color? colorSelected;
  IconData? iconSelected;

  final GlobalKey iconGlobalKey = GlobalKey();

  bool get confirmButtonEnabled => colorSelected != null && iconSelected != null;

  @override
  void initState() {
    super.initState();

    colorSelected = widget.color;
    iconSelected = widget.icon;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableBottomSheet(
      builder: (scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Text(strings.color, style: textTheme.titleMedium),
                  const Spacing.y(1.5),
                  Align(
                    alignment: Alignment.center,
                    child: Wrap(
                      runSpacing: 10,
                      children: colors
                          .map(
                            (color) => RawMaterialButton(
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.all(16),
                              shape: const CircleBorder(),
                              fillColor: color,
                              child: Icon(Icons.check, color: colorSelected == color ? Colors.white : Colors.transparent),
                              onPressed: () {
                                setState(() => colorSelected = color);
                                Scrollable.ensureVisible(iconGlobalKey.currentContext!, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const Spacing.y(2),
                  Text(
                    key: iconGlobalKey,
                    strings.icon,
                    style: textTheme.titleMedium,
                  ),
                  const Spacing.y(1.5),
                  Align(
                    alignment: Alignment.center,
                    child: Wrap(
                      runSpacing: 10,
                      children: icons
                          .map(
                            (IconData icon) => RawMaterialButton(
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.all(16),
                              shape: const CircleBorder(),
                              fillColor: iconSelected?.codePoint == icon.codePoint ? colorSelected : null,
                              child: Icon(icon, color: iconSelected?.codePoint == icon.codePoint ? Colors.white : null),
                              onPressed: () => setState(() => iconSelected = icon),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FilledButton(
                onPressed: confirmButtonEnabled ? () => context.pop<({Color color, IconData icon})?>((color: colorSelected!, icon: iconSelected!)) : null,
                child: Text(strings.confirm),
              ),
            ),
          ],
        );
      },
    );
  }

  static const List<IconData> icons = [
    Icons.beach_access_outlined,
    Icons.confirmation_number_outlined,
    Icons.handyman_outlined,
    Icons.home_outlined,
    Icons.local_gas_station_outlined,
    Icons.local_airport_outlined,
    Icons.airplane_ticket_outlined,
    Icons.monetization_on_outlined,
    Icons.person_outlined,
    Icons.card_giftcard_outlined,
    Icons.savings_outlined,
    Icons.videogame_asset_outlined,
    Icons.content_cut_outlined,
    Icons.tv_outlined,
    Icons.museum_outlined,
    Icons.music_note_outlined,
    Icons.cleaning_services_outlined,
    Icons.description_outlined,
    Icons.travel_explore_rounded,
    Icons.phone_android_outlined,
    Icons.photo_camera_outlined,
    Icons.sports_football_outlined,
    Icons.sports_bar_outlined,
    Icons.sports_esports_outlined,
    Icons.sports_basketball_outlined,
    Icons.smoking_rooms_outlined,
    Icons.cake_outlined,
    Icons.fitness_center_outlined,
    Icons.storefront_outlined,
    Icons.festival_rounded,
    Icons.business_center_outlined,
    Icons.spa_outlined,
    Icons.child_friendly_outlined,
    Icons.build_outlined,
    Icons.call_outlined,
    Icons.directions_bus_outlined,
    Icons.checkroom_outlined,
    Icons.shopping_cart_outlined,
    Icons.medical_services_outlined,
    Icons.fastfood_outlined,
    Icons.school_outlined,
    Icons.more_outlined,
    Icons.casino_outlined,
    Icons.ssid_chart_outlined,
    Icons.account_balance_outlined,
    Icons.directions_car_filled_outlined,
  ];

  static const List<Color> colors = [
    Color(0xFF000000),
    Color(0xFF3A3939),
    Color(0xFF727272),
    Color(0xFFA0725F),
    Color(0xFF099806),
    Color(0xFF37FF16),
    Color(0xFF30C280),
    Color(0xFF04CBBC),
    Color(0xFF05299E),
    Color(0xFF9800CD),
    Color(0xFFF85992),
    Color(0xFFE10252),
    Color(0xFFFF2012),
    Color(0xFFFF4D00),
    Color(0xFFF8C630),
    Color(0xFFFFE600),
  ];
}
