import 'package:flutter/material.dart';
import '../../../../common/presentation/build_context_extensions.dart';
import '../../../../common/presentation/extensions/localization_extension.dart';
import '../../../../common/presentation/spacing.dart';
import '../../domain/entities/feature_entity.dart';

class FeatureListItem extends StatelessWidget {
  final FeatureEntity feature;
  final VoidCallback onTap;
  
  const FeatureListItem({
    super.key,
    required this.feature,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: context.appColors.border,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                children: [
                  Expanded(
                    child: Text(
                      feature.name,
                      style: context.textStyles.bodyText1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (feature.isNew)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: context.appColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'New',  // Note: Add to ARB if needed for translation
                        style: context.textStyles.caption.copyWith(
                          color: context.appColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
              
              if (feature.hasDescription) ...[
                spacing8,
                Text(
                  feature.description!,
                  style: context.textStyles.greyBodyText2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              spacing8,
              Text(
                context.l10n.formattedDate(feature.createdAt),
                style: context.textStyles.caption.copyWith(
                  color: context.appColors.greyText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatRelativeDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) return context.l10n.dateToday;
    if (diff.inDays == 1) return context.l10n.dateYesterday;
    if (diff.inDays < 7) return context.l10n.daysAgo(diff.inDays);
    
    // For older dates, use formatted date
    return context.l10n.formattedDate(date);
  }
}

