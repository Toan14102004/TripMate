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
            child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
          );
        });

        _mapController.move(
          newPosition,
          16.0,
        );
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
      // Thay thế logDebug/logError của bạn
      // logError(e);
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
          data:
              context.isDarkMode
                  ? ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: Colors.orange.shade600,
                      onPrimary: Colors.white,
                      surface: const Color(0xFF1B1B1B),
                      onSurface: Colors.white,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.orange.shade600,
                      ),
                    ),
                  )
                  : ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Colors.blue.shade600,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black87,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue.shade600,
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
          // Update all controllers with state data
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
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                _buildInteractiveAvatarSection(),
                                const SizedBox(height: 30),
                                _buildAdvancedFormFields(),
                                const SizedBox(height: 40),
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
                                ? Colors.white.withOpacity(0.1)
                                : Colors.white,
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
                            context.isDarkMode ? Colors.white : Colors.black87,
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

  Widget _buildInteractiveAvatarSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showAvatarPicker(),
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 130 + (_pulseController.value * 10),
                    height: 130 + (_pulseController.value * 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.orange.withOpacity(0.3),
                          Colors.blue.withOpacity(0.1),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade400, Colors.blue.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _selectedAvatar,
                    style: const TextStyle(fontSize: 50),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showAvatarPicker(),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.orange.shade400],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: _waveController,
          builder: (context, child) {
            return Text(
              'Tap to customize!',
              style: TextStyle(
                fontSize: 14,
                color: (context.isDarkMode ? Colors.white : Colors.grey[600])
                    ?.withOpacity(
                      (0.7 +
                              0.3 *
                                  (0.5 +
                                      0.5 *
                                          Curves.easeInOut.transform(
                                            ((_waveController.value * 2) % 1.0),
                                          )))
                          .clamp(0.0, 1.0),
                    ),
                fontStyle: FontStyle.italic,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAdvancedFormFields() {
    return Column(
      children: [
        // Full Name
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

        // Username
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

        // Email
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

        // Phone Number
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

        // Date of Birth
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

        // Address
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
              _shakeAnimation();
            } else {
              // Lưu trạng thái trước khi thay đổi để kiểm tra
              final shouldShowMap = !_isMapVisible;

              setState(() {
                _isMapVisible = shouldShowMap;
              });

              ToastUtil.showInfoToast(
                _isMapVisible
                    ? 'Searching for: ${_addressController.text}'
                    : 'Map minimized.',
              );
              _shakeAnimation();

              if (_isMapVisible) {
                _geocodeAndShowMap();
              }
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    _isMapVisible ? Colors.red.shade400 : Colors.blue.shade400,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  _isMapVisible
                      ? 'Hide Map'
                      : 'Locate "${_addressController.text.isEmpty ? 'Address' : _addressController.text}" on Map 🗺️',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        _isMapVisible
                            ? Colors.red.shade400
                            : Colors.blue.shade400,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        if (_isMapVisible &&
            _mapCenter != null &&
            _addressController.text.isNotEmpty)
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade400, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
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
                  // Layer Bản đồ OpenStreetMap (Map Tiles)
                  TileLayer(
                    urlTemplate:
                        context.isDarkMode
                            ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                            : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                    subdomains: const ['a', 'b', 'c', 'd'],
                    userAgentPackageName: 'com.example.trip_mate',
                  ),
                  // Layer Marker
                  MarkerLayer(
                    markers: [if (_addressMarker != null) _addressMarker!],
                  ),

                  // --- NEW: Thêm Ghi nhận bản quyền OSM ---
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
                  // ----------------------------------------
                ],
              ),
            ),
          ),
        if (_isMapVisible && _mapCenter != null) const SizedBox(height: 16),

        // Role (Read-only with different styling)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.shade50.withOpacity(0.3),
                Colors.blue.shade50.withOpacity(0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  context.isDarkMode
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade400, Colors.blue.shade400],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.badge_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Role',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            context.isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _roleController.text,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            context.isDarkMode ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.5)),
                ),
                child: const Text(
                  'Verified',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
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
    return Row(
      children: [
        Flexible(
          child: GestureDetector(
            onTap: () async {
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
                      dob:
                          DateTime.tryParse(_dobController.text) ??
                          DateTime.now(),
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
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade400, Colors.blue.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(
                          (0.4 + 0.2 * _pulseController.value).clamp(0.0, 1.0),
                        ),
                        blurRadius: 20 + 10 * _pulseController.value,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Update Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:
                  context.isDarkMode ? const Color(0xFF1B1B1B) : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Your Avatar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.isDarkMode ? Colors.white : Colors.black87,
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
                        _shakeAnimation();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient:
                              _selectedAvatar == _avatarOptions[index]
                                  ? LinearGradient(
                                    colors: [
                                      Colors.orange.shade300,
                                      Colors.blue.shade300,
                                    ],
                                  )
                                  : null,
                          color:
                              _selectedAvatar == _avatarOptions[index]
                                  ? null
                                  : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            _avatarOptions[index],
                            style: const TextStyle(fontSize: 30),
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
