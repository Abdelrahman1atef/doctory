import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import '../../../cubit/ads/admin_ads_cubit.dart';
import '../../../cubit/ads/admin_ads_states.dart';
import '../../../data/model/ad_model.dart';

class AdminAdsBodySection extends StatelessWidget {
  const AdminAdsBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminAdsCubit, AdminAdsState>(
      builder: (context, state) {
        if (state is AdminAdsLoading) return const Center(child: CircularProgressIndicator());
        if (state is AdminAdsError) return Center(child: Text(state.message));
        if (state is AdminAdsLoaded) {
          final items = state.items;
          final active = items.where((a) => a.status == 'active').length;
          final totalImpressions = items.fold<int>(0, (sum, a) => sum + a.impressions);
          final totalClicks = items.fold<int>(0, (sum, a) => sum + a.clicks);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Wrap(
                spacing: 12, runSpacing: 12,
                children: [
                  _MiniStat('Total', '${items.length}', AppColors.stitchPrimary),
                  _MiniStat('Active', '$active', AppColors.success),
                  _MiniStat('Impressions', '$totalImpressions', AppColors.info),
                  _MiniStat('Clicks', '$totalClicks', AppColors.warning),
                ],
              ),
              const SizedBox(height: 16),
              ...items.map((ad) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [AppColors.stitchPrimary.withAlpha(100), AppColors.stitchPrimary.withAlpha(30)]),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(_adIcon(ad.type), color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ad.title, style: AppStyles.s14Bold),
                              Text(ad.type.name, style: AppStyles.s12Medium.withColor(AppColors.textSecondary)),
                            ],
                          )),
                          _StatusChip(ad.status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('${ad.startDate} - ${ad.endDate}', style: AppStyles.s12Medium.withColor(AppColors.textHint)),
                          const Spacer(),
                          Text('${ad.clicks} clicks / ${ad.impressions} impressions', style: AppStyles.s12Medium.withColor(AppColors.textHint)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('CTR: ${ad.ctr.toStringAsFixed(1)}%', style: AppStyles.s12Medium.withColor(ad.ctr >= 2 ? AppColors.success : ad.ctr >= 1 ? AppColors.warning : AppColors.errorColor)),
                      if (ad.linkedEntityName != null) ...[
                        const SizedBox(height: 4),
                        Text('Linked: ${ad.linkedEntityName}', style: AppStyles.s12Medium.withColor(AppColors.textHint)),
                      ],
                    ],
                  ),
                ),
              )),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  IconData _adIcon(AdType type) {
    switch (type) {
      case AdType.banner: return Icons.campaign;
      case AdType.featuredDoctor: return Icons.person;
      case AdType.featuredClinic: return Icons.business;
    }
  }
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _MiniStat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withAlpha(60))),
      child: Column(children: [Text(value, style: AppStyles.s20Bold.withColor(color)), Text(label, style: AppStyles.s12Medium.withColor(AppColors.textSecondary))]),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip(this.status);

  @override
  Widget build(BuildContext context) {
    Color c;
    switch (status) {
      case 'active': c = AppColors.success; break;
      case 'inactive': c = AppColors.grey5; break;
      case 'scheduled': c = AppColors.info; break;
      case 'expired': c = AppColors.errorColor; break;
      default: c = AppColors.grey5;
    }
    return Chip(label: Text(status, style: const TextStyle(fontSize: 10)), backgroundColor: c.withAlpha(30), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, visualDensity: VisualDensity.compact);
  }
}
