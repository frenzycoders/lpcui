import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lc_mobile/src/controller/manager_controller.dart';
import 'package:lc_mobile/widget/chart_widget.dart';
import 'package:lc_mobile/widget/storage_info_card.dart';

class SysDetails extends StatelessWidget {
  SysDetails({
    Key? key,
    required this.managerController,
  }) : super(key: key);
  ManagerController managerController;
  @override
  Widget build(BuildContext context) {
    final freeStorage =
        double.parse(managerController.sysDetails.value.free.split('.')[0]);
    final totatStorage = double.parse(
        managerController.sysDetails.value.totalSpace.split('.')[0]);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "System details",
                  style: GoogleFonts.firaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: Column(
                  children: [
                    ChartWidget(
                      firstDataSection: PieChartSectionData(
                        color: Colors.blueGrey,
                        value:
                            ((totatStorage - freeStorage) / totatStorage) * 100,
                        showTitle: true,
                        title: 'Used',
                        radius: 20,
                      ),
                      secondDataSection: PieChartSectionData(
                        color: Colors.black54,
                        value: (freeStorage / totatStorage) * 100,
                        showTitle: true,
                        title: 'Free',
                        radius: 20,
                      ),
                      icon: Icons.storage,
                      free: managerController.sysDetails.value.free
                              .split('.')[0] +
                          ' GB',
                      total: managerController.sysDetails.value.totalSpace
                              .split('.')[0] +
                          ' GB',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: Column(
                  children: [
                    ChartWidget(
                      firstDataSection: PieChartSectionData(
                        color: Colors.blueGrey,
                        value:
                            ((totatStorage - freeStorage) / totatStorage) * 100,
                        showTitle: true,
                        title: 'Used',
                        radius: 20,
                      ),
                      secondDataSection: PieChartSectionData(
                        color: Colors.black54,
                        value: (freeStorage / totatStorage) * 100,
                        showTitle: true,
                        title: 'Free',
                        radius: 20,
                      ),
                      icon: Icons.memory_outlined,
                      free: managerController.sysDetails.value.free
                              .split('.')[0] +
                          ' GB',
                      total: managerController.sysDetails.value.totalSpace
                              .split('.')[0] +
                          ' GB',
                    ),
                  ],
                ),
              ),
              StorageInfoCard(
                title: 'DISK',
                icon: Icons.storage,
                amountOfFiles: totatStorage.toString() + ' GB',
                numOfFiles: freeStorage.toString() + ' GB FREE',
              ),
              StorageInfoCard(
                title: 'RAM',
                icon: Icons.memory,
                amountOfFiles: '2' + ' GB',
                numOfFiles: '8' + ' GB FREE',
              ),
              StorageInfoCard(
                title: 'USER',
                icon: Icons.person,
                amountOfFiles: managerController.sysDetails.value.hostName,
                numOfFiles: managerController.sysDetails.value.homeDir,
              ),
              StorageInfoCard(
                title: 'OS',
                icon: Icons.ac_unit,
                amountOfFiles: managerController.sysDetails.value.release,
                numOfFiles: managerController.sysDetails.value.arch +
                    ' ' +
                    managerController.sysDetails.value.ostype,
              ),
              StorageInfoCard(
                title: 'DETAILS',
                icon: Icons.details,
                amountOfFiles: managerController.sysDetails.value.operatingSys,
                numOfFiles: managerController.sysDetails.value.version +
                    ' ' +
                    managerController.sysDetails.value.platform,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
