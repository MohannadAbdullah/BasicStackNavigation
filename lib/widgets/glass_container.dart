// import 'dart:ui';
// import 'package:flutter/material.dart';

// class GlassContainer extends StatelessWidget {
//   final Widget child;
//   final EdgeInsets? padding;

//   const GlassContainer({
//     super.key,
//     required this.child,
//     this.padding,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(16),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//         child: Container(
//           padding: padding ?? const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.white.withAlpha(40),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: Colors.white.withAlpha(60),
//             ),
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }
// }