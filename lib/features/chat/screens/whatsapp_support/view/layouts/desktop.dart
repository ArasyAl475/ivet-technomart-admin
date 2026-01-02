import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


import 'package:t_utils/t_utils.dart';

import '../widgets/table.dart';

class WhatsappSupportDesktopScreen extends StatelessWidget {
  const WhatsappSupportDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes().defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              TBreadcrumbsWithHeading(iconData: Iconsax.unlimited, heading: 'All Support', breadcrumbItems: ['All Support']),
              SizedBox(height: TSizes().spaceBtwSections),

              // Body
              WhatsappSupportTable(),
            ],
          ),
        ),
      ),
    );
  }
}
