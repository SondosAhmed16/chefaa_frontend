import 'package:chefaa_frontend/models/user_role.dart';
import 'package:chefaa_frontend/providers/register_providers.dart';
import 'package:chefaa_frontend/views/facility_selection_screen.dart';
import 'package:chefaa_frontend/views/register_doctor_screen.dart';
import 'package:chefaa_frontend/views/register_patient_screen.dart';
import 'package:chefaa_frontend/views/widgets/role_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  bool _isFacilitySelected = false;
  @override
  Widget build(BuildContext context) {
    final regiserProvider = context.watch<RegisterProviders>();
    final selectedRole = regiserProvider.selectedRole;

    final bool isSelected = selectedRole != null || _isFacilitySelected;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                color: Color(0xFF0066CC),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    "Chefaa",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Choose who you are',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  RoleCard(
                    userRole: UserRole.doctor,
                    isSelected:
                        selectedRole == UserRole.doctor && !_isFacilitySelected,
                    icon: Icons.medical_information,
                    onTap: () {
                      setState(() => _isFacilitySelected = false);
                      regiserProvider.selectRole(UserRole.doctor);
                    },
                  ),
                  RoleCard(
                    userRole: UserRole.patient,
                    isSelected:
                        selectedRole == UserRole.patient &&
                        !_isFacilitySelected,
                    icon: Icons.person,
                    onTap: () {
                      setState(() => _isFacilitySelected = false);
                      regiserProvider.selectRole(UserRole.patient);
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _isFacilitySelected = true);
                      regiserProvider.clearRole();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isFacilitySelected
                              ? const Color(0xFF0066CC)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.local_pharmacy,
                              color: Color(0xFF0066CC),
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Expanded(
                            child: Text(
                              'Facility',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _isFacilitySelected
                                    ? const Color(0xFF0066CC)
                                    : Colors.grey.shade400,
                                width: 2,
                              ),
                              color: _isFacilitySelected
                                  ? const Color(0xFF0066CC)
                                  : Colors.transparent,
                            ),
                            child: _isFacilitySelected
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: isSelected
                      ? () {
                          if (_isFacilitySelected) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FacilitySelectionScreen(),
                              ),
                            );
                          } else if (selectedRole == UserRole.patient) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterPatientScreen(),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterDoctorScreen(),
                              ),
                            );
                          }
                        }
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF0066CC)
                          : Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
