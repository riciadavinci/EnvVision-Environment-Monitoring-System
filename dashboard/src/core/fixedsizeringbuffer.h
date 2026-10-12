#pragma once
#include <cstddef>
#include <array>
#include <optional>
#include <vector>


const std::size_t DEFAULT_SLICE_SIZE {60};

template <typename Type, std::size_t Capacity>
class FixedSizeRingBuffer {
    static_assert(Capacity > 0, "Buffer Capacity must be greater than 0!");
public:
    FixedSizeRingBuffer() = default;

    void push(Type item) {
        m_data[m_head] = std::move(item);
        m_head = (m_head + 1) % Capacity;
        if (m_current_size != Capacity) {
            m_current_size++;
        } else {
            m_tail = (m_tail + 1) % Capacity;
        }
    }

    [[nodiscard]] std::optional<Type> get(std::size_t index) const {
        if (index >= m_current_size) {
            return std::nullopt;
        }
        auto physical_index = getPhysicalIndex(index);
        return m_data[physical_index];
    }

    [[nodiscard]] std::optional<Type> getAtPhysical(std::size_t index) const {
        if (index >= m_current_size) {
            return std::nullopt;
        }
        return m_data[index];
    }

    [[nodiscard]] std::optional<Type> getLatest() const {
        if (m_current_size == 0) {
            return std::nullopt;
        }
        // auto index = (m_head + Capacity - 1) % Capacity;
        auto index = getHeadPhysicalIndex();
        return m_data[index];
    }

    [[nodiscard]] std::optional<Type> getOldest() const {
        if (m_current_size == 0) {
            return std::nullopt;
        }
        return m_data[m_tail];
    }

    [[nodiscard]] std::vector<Type> getLatestSlice(std::size_t count = DEFAULT_SLICE_SIZE) const {
    	if ((m_current_size == 0) || (count == 0)) {
    		return {};
    	}
    	
        const std::size_t actual_count = std::min(count, m_current_size);

    	std::vector<Type> slice;
    	slice.reserve(actual_count);
    	
    	std::size_t start_index = ((m_head + Capacity - actual_count) % Capacity);
    	for (std::size_t i = 0; i < actual_count; ++i) {
    		std::size_t index = (start_index + i) % Capacity;
    		slice.push_back(m_data[index]);
    	}	
    
    	return slice;
    }

    [[nodiscard]] bool isEmpty() const {
        return (m_current_size == 0);
    }

    [[nodiscard]] bool isFull() const {
        return (m_current_size == Capacity);
    }

    // Getters:
    [[nodiscard]] std::size_t head() const {
        return m_head;
    }

    [[nodiscard]] std::size_t tail() const {
        return m_tail;
    }

    [[nodiscard]] std::size_t currentSize() const {
        return m_current_size;
    }

    [[nodiscard]] constexpr std::size_t capacity() const {
        return Capacity;
    }


private:
    [[nodiscard]] std::size_t getPhysicalIndex(std::size_t index) const {
        return (m_tail + index) % Capacity;
    }
    
    [[nodiscard]] std::size_t getHeadPhysicalIndex() const {
        return (m_head - 1 + Capacity) % Capacity;
    }

private:
    std::array<Type, Capacity> m_data {};
    std::size_t m_head {0UL};
    std::size_t m_tail {0UL};
    std::size_t m_current_size {0UL};
};