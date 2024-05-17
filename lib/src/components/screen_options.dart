import 'package:flutter/material.dart';
import 'package:reels_viewer/reels_viewer.dart';
import 'package:reels_viewer/src/components/user_profile_image.dart';

class ScreenOptions extends StatelessWidget {
  final ReelModel item;
  final bool showVerifiedTick;
  final Function(String)? onShare;
  final Function(String)? onLike;
  final Function(String)? onComment;
  final Function()? onClickMoreBtn;
  final Function()? onFollow;

  const ScreenOptions({
    Key? key,
    required this.item,
    this.showVerifiedTick = true,
    this.onClickMoreBtn,
    this.onComment,
    this.onFollow,
    this.onLike,
    this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (item.profileUrl != null)
                UserProfileImage(profileUrl: item.profileUrl ?? ''),
              if (item.profileUrl == null)
                const CircleAvatar(
                  child: Icon(Icons.person, size: 18),
                  radius: 16,
                ),
              const SizedBox(width: 6),
              Text(item.userName, style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 10),
              if (showVerifiedTick)
                const Icon(
                  Icons.verified,
                  size: 15,
                  color: Colors.white,
                ),
              if (showVerifiedTick) const SizedBox(width: 6),
              if (onFollow != null)
                TextButton(
                  onPressed: onFollow,
                  child: const Text(
                    'Follow',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 6),
          if (item.reelDescription != null)
            Text(item.reelDescription ?? '',
                style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
