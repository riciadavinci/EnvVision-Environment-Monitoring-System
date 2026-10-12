#pragma once

#include <QAbstractListModel>
#include <QPointF>
#include <QVector>

static int MAX_POINTS_CAPACITY = 60;

class TelemetryListModel : public QAbstractListModel {
    Q_OBJECT

public:
    enum Roles {
        XRole = Qt::UserRole + 1,
        YRole
    };

    explicit TelemetryListModel(QObject* parent = nullptr);

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;

    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

    QHash<int, QByteArray> roleNames() const override;

    int columnCount(const QModelIndex &parent = QModelIndex()) const;

    void loadSlice(const QVector<QPointF>& points);
    void appendPoint(double x, double y, int maxCapacity = MAX_POINTS_CAPACITY);

private:
    QVector<QPointF> m_points;
};
