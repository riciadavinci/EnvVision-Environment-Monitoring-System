#include "telemetry_list_model.h"


TelemetryListModel::TelemetryListModel(QObject* parent) 
    : QAbstractListModel {parent}
{
    m_points.reserve(MAX_POINTS_CAPACITY);
}

int TelemetryListModel::rowCount(const QModelIndex& parent) const {
    if (parent.isValid()) {
        return 0;
    }
    return m_points.size();
}

QVariant TelemetryListModel::data(const QModelIndex& index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_points.size()) {
        return QVariant();
    }

    if (role == Qt::DisplayRole || role == Qt::EditRole) {
        if (index.column() == 0) {
            return m_points[index.row()].x();
        }
        if (index.column() == 1) {
            return m_points[index.row()].y();
        }
    }
    // const QPointF& pt = m_points.at(index.row());
    // if (role == XRole) {return pt.x();}
    // if (role == YRole) {return pt.y();}

    return QVariant();
}

QHash<int, QByteArray> TelemetryListModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[XRole] = "xVal";
    roles[YRole] = "yVal";
    return roles;
}

int TelemetryListModel::columnCount(const QModelIndex &parent) const {
    Q_UNUSED(parent);

    return 2;
}



void TelemetryListModel::loadSlice(const QVector<QPointF>& points) {
    beginResetModel();
    m_points = points;
    endResetModel();
}

void TelemetryListModel::appendPoint(double x, double y, int maxCapacity) {
    if (m_points.size() > maxCapacity) {
        beginRemoveRows(QModelIndex(), 0, 0);
        m_points.removeFirst();
        endRemoveRows();
    }

    int insertIdx = static_cast<int>(m_points.size());

    beginInsertRows(QModelIndex(), insertIdx, insertIdx);
    m_points.append(QPointF(x, y));
    endInsertRows();
}
