import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    width: 400
    height: 450

    // Hız ve animasyon verileri
    property real speed: 0               
    property real maxSpeed: 200
    property real angleRange: 270
    property int frameCount: 0
    property int fps: 0

    // Sürekli paint tetikleyerek FPS ölçümü
    Timer {
        interval: 0
        running: true
        repeat: true
        onTriggered: faceCanvas.requestPaint()
    }

    // FPS ölçümü
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            fps = frameCount
            frameCount = 0
        }
    }

    Canvas {
        id: faceCanvas
        anchors.top: parent.top
        width: parent.width
        height: 400

        onPaint: {
            frameCount += 1

            const ctx = getContext("2d")
            ctx.reset()

            const cx = width / 2
            const cy = height / 2

            // Cat Face
            ctx.beginPath()
            ctx.arc(cx, cy, 130, 0, 2 * Math.PI)
            ctx.fillStyle = "#DADADA"
            ctx.fill()

            // Eyes
            ctx.beginPath()
            ctx.ellipse(cx - 40, cy - 30, 10, 15, 0, 0, 2 * Math.PI)
            ctx.fillStyle = "black"
            ctx.fill()

            ctx.beginPath()
            ctx.ellipse(cx + 40, cy - 30, 10, 15, 0, 0, 2 * Math.PI)
            ctx.fill()

            // Nose
            ctx.beginPath()
            ctx.arc(cx, cy, 10, 0, 2 * Math.PI)
            ctx.fill()

            // Mount
            ctx.beginPath()
            ctx.moveTo(cx, cy + 10)
            ctx.bezierCurveTo(cx - 15, cy + 25, cx - 5, cy + 25, cx - 20, cy + 30)
            ctx.moveTo(cx, cy + 10)
            ctx.bezierCurveTo(cx + 15, cy + 25, cx + 5, cy + 25, cx + 20, cy + 30)
            ctx.strokeStyle = "black"
            ctx.lineWidth = 3
            ctx.stroke()
        }

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
    }

    // Needle
    Rectangle {
        id: needle
        width: 4
        height: 100
        radius: 2
        color: "red"
        anchors.horizontalCenter: faceCanvas.horizontalCenter
        anchors.bottom: faceCanvas.verticalCenter  // Altı merkeze oturt

        
        transform: Rotation {
            id: needleRotation
            origin.x: (needle.width / 2 ) 
            origin.y: needle.height
            angle: -135 + (speed / maxSpeed) * angleRange
            Behavior on angle {
                
                NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
            }
        }
    }

    // Digital speedmeter Gauge
    Text {
        text: Math.round(speed) + " MPH"
        font.pixelSize: 26
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: speedSlider.top
        anchors.bottomMargin: 8
    }

    // FPS text
    Text {
        text: "FPS: " + fps
        color: "lime"
        font.pixelSize: 16
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 10
    }

    // Slider - speed control
    Slider {
        id: speedSlider
        width: parent.width - 40
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10

        from: 0
        to: maxSpeed
        value: speed

        onValueChanged: {
           
            speed = value
            
        }
    }


    // Background
    Rectangle {
        anchors.fill: parent
        z: -1
        color: "#222"
    }
}
