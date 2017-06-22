TEMPLATE = app

QT += qml quick widgets
QT += network
CONFIG += c++11

CONFIG += declarative_debug
CONFIG += qml_debug

isEmpty(LIBUSB_LIBRARY) {
  LIBUSB_LIBRARY = "C:\Users\cpop\Downloads\libsmu\libsmu-0.9.0-g5cf7ec8\libsmu\64\libusb-1.0.lib"
}

isEmpty(LIBUSB_INCLUDE_PATH) {
  LIBUSB_INCLUDE_PATH = "C:\Users\cpop\Downloads\libsmu-0.9.0-g5cf7ec8\libsmu\include\libsmu"
}

isEmpty(LIBSMU_LIBRARY) {
  LIBSMU_LIBRARY = "C:\Users\cpop\Downloads\libsmu\libsmu-0.9.0-g5cf7ec8\libsmu\64\libsmu.lib"
}

isEmpty(LIBSMU_INCLUDE_PATH) {
  LIBSMU_INCLUDE_PATH = "C:\Users\cpop\Downloads\libsmu-0.9.0-g5cf7ec8\libsmu\include"
}

equals(TEMPLATE, "app") {
  DEFINES += GIT_VERSION='"\\\"$${system(git -C $$PWD describe --always --tags --abbrev)}\\\""'
  DEFINES += BUILD_DATE='"\\\"$${system(date /t +%F)}\\\""'
}

equals(TEMPLATE, "vcapp") {
  DEFINES += GIT_VERSION='"$${system(git -C $$PWD describe --always --tags --abbrev)}"'
  DEFINES += BUILD_DATE='"$${system(date /t +%F)}"'

  # It is needed to remove the GIT_VERSION and BUILD_DATE defines from the RC preprocessor macros,
  # otherwise the RC compiler will fail.
  RC_DEFINES += DEFINES
  RC_DEFINES -= GIT_VERSION
  RC_DEFINES -= BUILD_DATE
}

win32 {
        CONFIG += release
}
unix {
        CONFIG += release
}

QMAKE_CFLAGS_DEBUG += -ggdb
QMAKE_CXXFLAGS_DEBUG += -ggdb

CFLAGS += -v -static -static-libgcc -static-libstdc++ -g

SOURCES += main.cpp \
    SMU.cpp \
    Plot/PhosphorRender.cpp \
    Plot/FloatBuffer.cpp \
    utils/filedownloader.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in the Qt Creator code model
QML_IMPORT_PATH =

OTHER_FILES += \
    qml/main.qml \
    qml/Toolbar.qml \
    qml/PlotPane.qml \
    qml/DeviceManagerPane.qml \
    qml/ToolbarStyle.qml \
    qml/ContentPane.qml \
    qml/XYPlot.qml \
    qml/Controller.qml \
    qml/SignalRow.qml \
    qml/ChannelRow.qml \
    qml/OverlayConstant.qml \
    qml/TimelineFlickable.qml \
    qml/TimelineHeader.qml \
    qml/Axes.qml \
    qml/OverlayPeriodic.qml \
    qml/DragDot.qml \
    qml/DeviceRow.qml \
    qml/AcquisitionSettingsDialog.qml

HEADERS += \
    SMU.h \
    Plot/PhosphorRender.h \
    Plot/FloatBuffer.h \
    utils/fileio.h \
    utils/bossac_wrap.h \
    utils/filedownloader.h

win32:debug {
#	CONFIG += console
	LIBS += -limagehlp -ldbghelp
}


osx {
	ICON = icons/pp2.icns
        LIBS += -lobjc -framework IOKit -framework CoreFoundation
        QT_LOGGING_RULES=qt.network.ssl.warning=false
}

win32 {
	RC_ICONS = icons/pp2.ico
	LIBS += $${LIBUSB_LIBRARY}
	INCLUDEPATH += $${LIBUSB_INCLUDE_PATH}

        LIBS += $${LIBSMU_LIBRARY}
        INCLUDEPATH += $${LIBSMU_INCLUDE_PATH}
}

unix {
	CONFIG += link_pkgconfig
PKGCONFIG += libsmu
# if we do not have a locally compiled static version of libusb-1.0 installed, use pkg-config
	!exists(/usr/local/lib/libusb-1.0.a) {
		PKGCONFIG += libusb-1.0
	}
# if we do have a locally compiled static version of libusb-1.0 installed, use it
	exists(/usr/local/lib/libusb-1.0.a) {
		LIBS += /usr/local/lib/libusb-1.0.a
                INCLUDEPATH += "/usr/local/include/libusb-1.0"
	}
}

unix:!osx {
	PKGCONFIG += libudev
	INSTALLS+=target
	isEmpty(PREFIX) {
		PREFIX = /usr
	}
	BINDIR = $$PREFIX/bin
	target.path=$$BINDIR
	QMAKE_CFLAGS_DEBUG += -rdynamic
	QMAKE_CXXFLAGS_DEBUG += -rdynamic
}
