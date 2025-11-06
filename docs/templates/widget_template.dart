import 'package:flutter/material.dart';
import '../../../../common/presentation/build_context_extensions.dart';
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
                        'New',
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
                'Created ${_formatDate(feature.createdAt)}',
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
  
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) return 'today';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}

