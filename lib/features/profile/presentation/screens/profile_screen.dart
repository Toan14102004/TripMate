import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:trip_mate/commons/helpers/is_dark_mode.dart';
import 'package:trip_mate/commons/log.dart';
import 'package:trip_mate/commons/widgets/error_screen.dart';
import 'package:trip_mate/commons/widgets/loading_screen.dart';
import 'package:trip_mate/core/configs/theme/app_colors.dart';
import 'package:trip_mate/core/ultils/toast_util.dart';
import 'package:trip_mate/features/profile/presentation/providers/profile_bloc.dart';
import 'package:trip_mate/features/profile/presentation/providers/profile_state.dart';
import 'package:trip_mate/features/profile/presentation/widgets/action_buttons.dart';
import 'package:trip_mate/features/profile/presentation/widgets/success_dialog.dart';
import 'package:trip_mate/features/profile/presentation/widgets/text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _AdvancedProfilePageState createState() => _AdvancedProfilePageState();
}

class _AdvancedProfilePageState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late AnimationController _waveController;

  bool _isEditing = false;
  String _selectedAvatar = '😊';
  bool _isMapVisible = false;
  LatLng? _mapCenter;
  Marker? _addressMarker;
  final MapController _mapController = MapController();
  final List<String> _avatarOptions = [
    '😊',
    '🤔',
    '😎',
    '🚀',
    '💪',
    '🎯',
    '✨',
    '🌟',
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _mapCenter = const LatLng(21.028511, 105.804817);
    context.read<ProfileCubit>().initialize();
  }

  Future<void> _geocodeAndShowMap() async {
    final address = _addressController.text.trim();
    if (address.isEmpty) {
      ToastUtil.showErrorToast('Vui lòng nhập địa chỉ trước!');
      _shakeAnimation();
      return;
    }

    setState(() {
      _isMapVisible = true;
      _addressMarker = null;
    });

    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        final location = locations.first;
        final newPosition = LatLng(location.latitude, location.longitude);

        setState(() {
          _mapCenter = newPosition;
          _addressMarker = Marker(
            point: newPosition,
            width: 80,
            height: 80,
            child: const Icon(Icons.location_pin, color: AppColors.error, size: 40),
          );
        });

        _mapController.move(newPosition, 16.0);
        ToastUtil.showSuccessToast('Đã tìm thấy vị trí trên bản đồ!');
      } else {
        ToastUtil.showErrorToast('Không tìm thấy tọa độ cho địa chỉ này.');
        setState(() {
          _isMapVisible = false;
        });
      }
    } catch (e) {
      ToastUtil.showErrorToast(
        'Lỗi tìm kiếm: Vui lòng kiểm tra địa chỉ và kết nối mạng.',
      );
      setState(() {
        _isMapVisible = false;
      });
    }
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _pulseController.repeat(reverse: true);
    _waveController.repeat();
  }

  void _startAnimations() {
    Future.delayed(
      const Duration(milliseconds: 100),
      () => _scaleController.forward(),
    );
    Future.delayed(
      const Duration(milliseconds: 300),
      () => _fadeController.forward(),
    );
    Future.delayed(
      const Duration(milliseconds: 500),
      () => _slideController.forward(),
    );
  }

  void _shakeAnimation() {
    HapticFeedback.lightImpact();
    _shakeController.forward().then((_) => _shakeController.reset());
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_dobController.text) ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data:context.isDarkMode
                  ? ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: AppColors.primaryDark,
                      onPrimary: AppColors.black,
                      surface: AppColors.black,
                      onSurface: AppColors.white,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryDark,
                      ),
                    ),
                  )
                  :  ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
      context.read<ProfileCubit>().onChangeProfile(
        dob: DateTime.parse(_dobController.text),
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _shakeController.dispose();
    _waveController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _userNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileError) {
          return TravelErrorScreen(
            errorMessage: state.message,
            onRetry: () => context.read<ProfileCubit>().initialize(),
          );
        } else if (state is ProfileData) {
          _nameController.text = state.fullname;
          _emailController.text = state.email;
          _dobController.text =
              "${state.dob.year}-${state.dob.month.toString().padLeft(2, '0')}-${state.dob.day.toString().padLeft(2, '0')}";
          _userNameController.text = state.userName;
          _phoneController.text = state.phoneNumber;
          _addressController.text = state.address;
          _roleController.text = state.role;

          return Scaffold(
            backgroundColor:
                context.isDarkMode ? const Color(0xFF1B1B1B) : Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  _buildAdvancedHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.5),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _slideController,
                            curve: Curves.elasticOut,
                          ),
                        ),
                        child: FadeTransition(
                          opacity: _fadeController,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                _buildAvatarSection(),
                                const SizedBox(height: 28),
                                _buildFormFields(),
                                const SizedBox(height: 32),
                                _buildActionButtons(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const TravelLoadingScreen();
      },
    );
  }
   Widget _buildAdvancedHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              context.isDarkMode
                  ? [const Color(0xFF2E1A1A), const Color(0xFF1A2E2E)]
                  : [Colors.orange.shade50, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              _rotationController.forward().then(
                (_) => _rotationController.reset(),
              );
              _shakeAnimation();
              Navigator.of(context).pop();
            },
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _rotationController,
                _shakeController,
              ]),
              builder: (context, child) {
                double shake = 0;
                if (_shakeController.isAnimating) {
                  shake = 5 * (0.5 - (0.5 - _shakeController.value).abs());
                }
                return Transform.translate(
                  offset: Offset(shake, 0),
                  child: Transform.rotate(
                    angle: _rotationController.value * 2 * 3.14159,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            context.isDarkMode
                                ? AppColors.white.withOpacity(0.1)
                                : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color:
                            context.isDarkMode ? AppColors.white : AppColors.black,
                        size: 20,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          Colors.orange.shade400,
                          const Color(0xFF1B1B1B),
                          const Color(0xFF1B1B1B),
                          Colors.blue.shade400,
                        ],
                        stops:
                            [
                              _waveController.value - 0.3,
                              _waveController.value - 0.1,
                              _waveController.value + 0.1,
                              _waveController.value + 0.3,
                            ].map((e) => e.clamp(0.0, 1.0)).toList(),
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds);
                    },
                    child: const Text(
                      'My Profile ✨',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showQuickActionsDialog(context);
              _shakeAnimation();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    context.isDarkMode
                        ? Colors.yellow.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.apps_rounded,
                color: context.isDarkMode ? Colors.yellow : Colors.grey[700],
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showAvatarPicker(),
          child: Stack(
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _selectedAvatar,
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: AppColors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Tap to customize',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.grey500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        AdvancedTextField(
          label: 'Full Name',
          icon: Icons.person_outline,
          controller: _nameController,
          delay: 0,
          isEditing: _isEditing,
          onToggleEdit: () => setState(() => _isEditing = !_isEditing),
          onSelectDate: _selectDate,
          onTextChange: (value) {
            context.read<ProfileCubit>().onChangeProfile(fullname: value);
          },
        ),
        const SizedBox(height: 16),
        AdvancedTextField(
          label: 'Username',
          icon: Icons.alternate_email,
          controller: _userNameController,
          delay: 100,
          isEditing: false,
          onToggleEdit: () => setState(() => _isEditing = !_isEditing),
          onSelectDate: _selectDate,
          onTextChange: (value) {
            context.read<ProfileCubit>().onChangeProfile(userName: value);
          },
        ),
        const SizedBox(height: 16),
        AdvancedTextField(
          label: 'Email',
          icon: Icons.email_outlined,
          controller: _emailController,
          delay: 200,
          isEditing: false,
          onToggleEdit: () => setState(() => _isEditing = !_isEditing),
          onSelectDate: _selectDate,
          onTextChange: (value) {
            context.read<ProfileCubit>().onChangeProfile(email: value);
          },
        ),
        const SizedBox(height: 16),
        AdvancedTextField(
          label: 'Phone Number',
          icon: Icons.phone_outlined,
          controller: _phoneController,
          delay: 300,
          isEditing: _isEditing,
          onToggleEdit: () => setState(() => _isEditing = !_isEditing),
          onSelectDate: _selectDate,
          onTextChange: (value) {
            context.read<ProfileCubit>().onChangeProfile(phoneNumber: value);
          },
        ),
        const SizedBox(height: 16),
        AdvancedTextField(
          label: 'Date of Birth',
          icon: Icons.calendar_today_outlined,
          controller: _dobController,
          delay: 400,
          isEditing: _isEditing,
          onToggleEdit: () => setState(() => _isEditing = !_isEditing),
          onSelectDate: _selectDate,
          onTextChange: (value) {},
        ),
        const SizedBox(height: 16),
        AdvancedTextField(
          label: 'Address',
          icon: Icons.location_on_outlined,
          controller: _addressController,
          delay: 500,
          isEditing: _isEditing,
          onToggleEdit: () => setState(() => _isEditing = !_isEditing),
          onSelectDate: _selectDate,
          onTextChange: (value) {
            context.read<ProfileCubit>().onChangeProfile(address: value);
            if (_isMapVisible) {
              setState(() => _isMapVisible = false);
            }
          },
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            if (_addressController.text.isEmpty) {
              ToastUtil.showErrorToast('Please enter an address first!');
            } else {
              setState(() {
                _isMapVisible = !_isMapVisible;
              });
              if (_isMapVisible) {
                _geocodeAndShowMap();
              }
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 52,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.isDarkMode ? AppColors.black : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isMapVisible ? AppColors.error : AppColors.primary,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: (_isMapVisible ? AppColors.error : AppColors.primary).withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _isMapVisible ? 'Hide Map' : 'Show on Map',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _isMapVisible ? AppColors.error : AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_isMapVisible && _mapCenter != null && _addressController.text.isNotEmpty)
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _mapCenter!,
                  initialZoom: 16.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                    subdomains: const ['a', 'b', 'c', 'd'],
                    userAgentPackageName: 'com.example.trip_mate',
                  ),
                  MarkerLayer(
                    markers: [if (_addressMarker != null) _addressMarker!],
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap:
                            () => launchUrl(
                              Uri.parse('https://openstreetmap.org/copyright'),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        if (_isMapVisible && _mapCenter != null) const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary, width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.badge_outlined,
                  color: AppColors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Role',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _roleController.text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.success, width: 0.5),
                ),
                child: Text(
                  'Verified',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () async {
          if (_emailController.text.isEmpty ||
              _dobController.text.isEmpty ||
              _nameController.text.isEmpty ||
              _userNameController.text.isEmpty ||
              _phoneController.text.isEmpty ||
              _addressController.text.isEmpty) {
            ToastUtil.showErrorToast('Please fill all fields');
          } else {
            final currentState = context.read<ProfileCubit>().state;
            if (currentState is ProfileData) {
              logDebug(currentState.userId);
              await context.read<ProfileCubit>().updateProfile(
                ProfileData(
                  userId: currentState.userId,
                  email: _emailController.text,
                  dob: DateTime.tryParse(_dobController.text) ?? DateTime.now(),
                  fullname: _nameController.text,
                  userName: _userNameController.text,
                  phoneNumber: _phoneController.text,
                  address: _addressController.text,
                  role: _roleController.text,
                  latitude: _mapCenter!.latitude,
                  longitude: _mapCenter!.longitude,
                ),
              );
              showSuccessAnimation(context);
              HapticFeedback.heavyImpact();
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
        child: Text(
          'Update Profile',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.isDarkMode ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Your Avatar',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: _avatarOptions.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedAvatar = _avatarOptions[index]);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: _selectedAvatar == _avatarOptions[index]
                          ? LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                          )
                          : null,
                      color: _selectedAvatar == _avatarOptions[index]
                          ? null
                          : AppColors.grey100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        _avatarOptions[index],
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
