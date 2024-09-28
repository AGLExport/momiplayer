// Copyright (C) 2021 The Qt Company Ltd.
// Copyright (C) 2024 Automotive Grade Linux
// SPDX-License-Identifier: GPL-3.0+

#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QCoreApplication::setApplicationName("MomiPlayer");

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::quit, &app, &QGuiApplication::quit);

    engine.loadFromModule("MediaPlayerModule", "Main");

    return app.exec();
}
