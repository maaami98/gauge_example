import sys
from PySide6.QtWidgets import QApplication
from PySide6.QtQuick import QQuickView
from PySide6.QtCore import QUrl

app = QApplication(sys.argv)

view = QQuickView()
view.setSource(QUrl("gauge.qml"))
view.setResizeMode(QQuickView.SizeRootObjectToView)
view.show()

sys.exit(app.exec())
