// Dialog để chọn ngân hàng với tìm kiếm
import 'package:flutter/material.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/features/wallet/domain/entities/bank_model.dart';

class BankSelectionDialog extends StatefulWidget {
  final List<Bank> banks;
  final Bank? selectedBank;
  final bool isDarkMode;
  final Function(Bank) onBankSelected;

  const BankSelectionDialog({
    super.key,
    required this.banks,
    required this.selectedBank,
    required this.isDarkMode,
    required this.onBankSelected,
  });

  @override
  State<BankSelectionDialog> createState() => _BankSelectionDialogState();
}

class _BankSelectionDialogState extends State<BankSelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Bank> _filteredBanks = [];

  @override
  void initState() {
    super.initState();
    _filteredBanks = widget.banks;
    _searchController.addListener(_filterBanks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBanks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBanks = widget.banks.where((bank) {
        return bank.name.toLowerCase().contains(query) ||
            bank.shortName.toLowerCase().contains(query) ||
            bank.code.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: widget.isDarkMode 
          ? AppColors.surfaceDark 
          : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Bank',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: widget.isDarkMode 
                        ? AppColors.white 
                        : AppColors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: widget.isDarkMode 
                        ? AppColors.grey400 
                        : AppColors.grey600,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Bar
            TextField(
              controller: _searchController,
              style: TextStyle(
                color: widget.isDarkMode 
                    ? AppColors.white 
                    : AppColors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Search bank name...',
                hintStyle: TextStyle(
                  color: widget.isDarkMode 
                      ? AppColors.grey500 
                      : AppColors.grey400,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: widget.isDarkMode 
                      ? AppColors.grey400 
                      : AppColors.grey600,
                ),
                filled: true,
                fillColor: widget.isDarkMode 
                    ? AppColors.darkBackground 
                    : AppColors.grey50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bank List
            Expanded(
              child: _filteredBanks.isEmpty
                  ? Center(
                      child: Text(
                        'No banks found',
                        style: TextStyle(
                          color: widget.isDarkMode 
                              ? AppColors.grey400 
                              : AppColors.grey600,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredBanks.length,
                      itemBuilder: (context, index) {
                        final bank = _filteredBanks[index];
                        final isSelected = widget.selectedBank?.id == bank.id;

                        return InkWell(
                          onTap: () => widget.onBankSelected(bank),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (widget.isDarkMode 
                                      ? AppColors.primaryDark.withOpacity(0.2)
                                      : AppColors.primaryLight)
                                  : (widget.isDarkMode 
                                      ? AppColors.darkBackground 
                                      : AppColors.grey50),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: isSelected ? 2 : 0,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Bank Logo
                                if (bank.logo.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      bank.logo,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: widget.isDarkMode 
                                                ? AppColors.grey700 
                                                : AppColors.grey200,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.account_balance,
                                            color: widget.isDarkMode 
                                                ? AppColors.grey400 
                                                : AppColors.grey600,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                const SizedBox(width: 12),
                                
                                // Bank Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bank.shortName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: widget.isDarkMode 
                                              ? AppColors.white 
                                              : AppColors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        bank.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: widget.isDarkMode 
                                              ? AppColors.grey400 
                                              : AppColors.grey600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Check Icon
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}