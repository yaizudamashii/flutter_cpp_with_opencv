import 'dart:ffi'; // For FFI
import 'dart:io'; // For Platform.isX

final DynamicLibrary stdlib = DynamicLibrary.process();

typedef PosixMallocNative = Pointer Function(IntPtr);
typedef PosixMalloc = Pointer Function(int);
final PosixMalloc posixMalloc =
stdlib.lookupFunction<PosixMallocNative, PosixMalloc>("malloc");

typedef PosixFreeNative = Void Function(Pointer);
typedef PosixFree = void Function(Pointer);
final PosixFree posixFree =
stdlib.lookupFunction<PosixFreeNative, PosixFree>("free");

final DynamicLibrary nativeAddLib =
    Platform.isAndroid ? DynamicLibrary.open("libnative_with_opencv.so") : DynamicLibrary.process();

final int Function(int x, int y) nativeAdd =
    nativeAddLib.lookup<NativeFunction<Int32 Function(Int32, Int32)>>("native_add").asFunction();

final Pointer<Uint8> Function(Pointer<Uint8> original) resizeInterArea =
    nativeAddLib.lookup<NativeFunction<Pointer<Uint8> Function(Pointer<Uint8>)>>("resize_inter_area").asFunction();

Pointer<T> allocate<T extends NativeType>({int count = 1}) {
    final int totalSize = count * sizeOf<T>();
    Pointer<T> result = posixMalloc(totalSize).cast();
    if (result.address == 0) {
        throw ArgumentError("Could not allocate $totalSize bytes.");
    }
    return result;
}

void free(Pointer ptr) {
    posixFree(ptr);
}