import 'dart:io';
import 'package:anymex/screens/manga/controller/reader_controller.dart';
import 'package:anymex/utils/function.dart';
import 'package:anymex/widgets/common/custom_tiles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:manga_page_view/manga_page_view.dart';

class ReaderSettings {
  final ReaderController controller;
  ReaderSettings({required this.controller});

  void showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
                  child: Center(
                    child: Text(
                      'Reader Settings',
                      style: TextStyle(
                          fontSize: 18, fontFamily: 'Poppins-SemiBold'),
                    ),
                  ),
                ),
                Obx(() {
                  final currentLayout = controller.readingLayout.value;
                  return CustomTile(
                    title: 'Layout',
                    description: switch (currentLayout) {
                      MangaPageViewMode.continuous => 'Continuous',
                      MangaPageViewMode.paged => 'Paged',
                    },
                    icon: Iconsax.card,
                    postFix: Row(
                      spacing: 4,
                      children: [
                        for (final layout in [
                          MangaPageViewMode.continuous,
                          MangaPageViewMode.paged
                        ])
                          IconButton.filled(
                            isSelected: layout == currentLayout,
                            tooltip: switch (layout) {
                              MangaPageViewMode.continuous => 'Continuous',
                              MangaPageViewMode.paged => 'Paged',
                            },
                            icon: switch (layout) {
                              MangaPageViewMode.continuous =>
                                const Icon(Icons.view_day),
                              MangaPageViewMode.paged =>
                                const Icon(Icons.auto_stories_rounded),
                            },
                            onPressed: () {
                              controller.changeReadingLayout(layout);
                            },
                          )
                      ],
                    ),
                  );
                }),
                Obx(() {
                  final currentDirection = controller.readingDirection.value;
                  return CustomTile(
                    title: 'Direction',
                    description: switch (currentDirection) {
                      MangaPageViewDirection.down => "Top-Down",
                      MangaPageViewDirection.right => "LTR",
                      MangaPageViewDirection.up => "Bottom-Up",
                      MangaPageViewDirection.left => "RTL",
                    },
                    icon: Iconsax.card,
                    postFix: Row(
                      spacing: 4,
                      children: [
                        for (final direction in [
                          MangaPageViewDirection.down,
                          MangaPageViewDirection.right,
                          MangaPageViewDirection.up,
                          MangaPageViewDirection.left,
                        ])
                          IconButton.filled(
                            isSelected: direction == currentDirection,
                            tooltip: switch (direction) {
                              MangaPageViewDirection.down => "Top-Down",
                              MangaPageViewDirection.right => "LTR",
                              MangaPageViewDirection.up => "Bottom-Up",
                              MangaPageViewDirection.left => "RTL",
                            },
                            icon: switch (direction) {
                              MangaPageViewDirection.down =>
                                const Icon(Icons.swipe_down_alt_rounded),
                              MangaPageViewDirection.right =>
                                const Icon(Icons.swipe_right_alt_rounded),
                              MangaPageViewDirection.up =>
                                const Icon(Icons.swipe_up_alt_rounded),
                              MangaPageViewDirection.left =>
                                const Icon(Icons.swipe_left_alt_rounded),
                            },
                            onPressed: () {
                              controller.changeReadingDirection(direction);
                            },
                          )
                      ],
                    ),
                  );
                }),
                Obx(() {
                  return CustomSwitchTile(
                    icon: Icons.fast_forward,
                    title: "Spaced Pages",
                    description: "Continuous Mode only",
                    switchValue: controller.spacedPages.value,
                    onChanged: (val) => controller.toggleSpacedPages(),
                  );
                }),
                if (!Platform.isAndroid && !Platform.isIOS)
                  Obx(() {
                    return CustomSliderTile(
                      title: 'Image Width',
                      sliderValue: controller.pageWidthMultiplier.value,
                      onChanged: (double value) {
                        controller.pageWidthMultiplier.value = value;
                      },
                      onChangedEnd: (e) => controller.savePreferences(),
                      description: 'Continuous Mode only',
                      icon: Icons.image_aspect_ratio_rounded,
                      min: 1.0,
                      max: 4.0,
                      divisions: 39,
                    );
                  }),
                if (!Platform.isAndroid && !Platform.isIOS)
                  Obx(() {
                    return CustomSliderTile(
                      title: 'Scroll Multiplier',
                      sliderValue: controller.scrollSpeedMultiplier.value,
                      onChanged: (double value) {
                        controller.scrollSpeedMultiplier.value = value;
                      },
                      onChangedEnd: (e) => controller.savePreferences(),
                      description:
                          'Adjust Key Scrolling Speed (Up, Down, Left, Right)',
                      icon: Icons.speed,
                      min: 1.0,
                      max: 5.0,
                      divisions: 9,
                    );
                  }),
                20.height()
              ],
            ),
          ),
        );
      },
    );
  }
}
