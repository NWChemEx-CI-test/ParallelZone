#pragma once

#include <bphash/Hasher.hpp>
#include <bphash/types/All.hpp>
#include <functional>

namespace runtime {

using Hasher    = bphash::Hasher;
using HashValue = bphash::HashValue;
using HashType  = bphash::HashType;

inline auto make_hasher() { return Hasher(HashType::Hash128); }

template<typename... Args>
auto hash_objects(Args&&... args) {
    auto h = make_hasher();
    h(std::forward<Args>(args)...);
    return bphash::hash_to_string(h.finalize());
}

} // namespace runtime

namespace std {
template<typename T>
void hash_object(const reference_wrapper<T>& ref, bphash::Hasher& h) {
    h(ref.get());
}

} // namespace std
