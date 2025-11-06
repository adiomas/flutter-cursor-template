import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../common/presentation/build_context_extensions.dart';
import '../../../../common/presentation/extensions/localization_extension.dart';
import '../../../../common/presentation/spacing.dart';
import '../../domain/notifiers/features_list_notifier.dart';
import '../widgets/feature_list_item.dart';
import '../widgets/loading_shimmer.dart';

class FeaturesPage extends HookConsumerWidget {
  static const routeName = '/features';
  
  const FeaturesPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuresState = ref.watch(featuresListNotifierProvider);
    
    useEffect(
      () {
        Future.microtask(() {
          ref.read(featuresListNotifierProvider.notifier).loadFeatures();
        });
        return null;
      },
      const [],
    );
    
    Future<void> onRefresh() async {
      await ref.read(featuresListNotifierProvider.notifier).loadFeatures();
    }
    
    return Scaffold(
      backgroundColor: context.appColors.contentBackground,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        title: Text(context.l10n.featuresTitle),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: switch (featuresState) {
          BaseLoading() => const FeaturesLoadingShimmer(),
          BaseData(:final data) => data.isEmpty
              ? const EmptyFeaturesView()
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.length,
                  separatorBuilder: (_, __) => spacing12,
                  itemBuilder: (context, index) {
                    return FeatureListItem(
                      feature: data[index],
                      onTap: () {
                        // Navigate to details
                      },
                    );
                  },
                ),
          BaseError(:final failure) => ErrorView(
              failure: failure,
              onRetry: onRefresh,
            ),
          _ => const SizedBox.shrink(),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EmptyFeaturesView extends StatelessWidget {
  const EmptyFeaturesView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 64,
            color: context.appColors.greyText,
          ),
          spacing16,
          Text(
            context.l10n.emptyListTitle,
            style: context.textStyles.headline2,
          ),
          spacing8,
          Text(
            context.l10n.emptyListMessage,
            style: context.textStyles.greyBodyText1,
          ),
        ],
      ),
    );
  }
}

