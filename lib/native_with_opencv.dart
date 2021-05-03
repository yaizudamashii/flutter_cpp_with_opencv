import 'dart:ffi'; // For FFI
import 'dart:io'; // For Platform.isX

final DynamicLibrary nativeAddLib =
    Platform.isAndroid ? DynamicLibrary.open("libnative_with_opencv.so") : DynamicLibrary.process();

final int Function(int x, int y) nativeAdd =
    nativeAddLib.lookup<NativeFunction<Int32 Function(Int32, Int32)>>("native_add").asFunction();

final Pointer<Uint8> Function(Pointer<Uint8> original, int originalWidth, int originalHeight, int resizedWidth, int resizedHeight) resizeInterArea =
    nativeAddLib.lookup<NativeFunction<Pointer<Uint8> Function(Pointer<Uint8>, Int32, Int32, Int32, Int32)>>("resize_inter_area").asFunction();

Pointer<T> allocate<T extends NativeType>({int count = 1}) {
    final int totalSize = count * sizeOf<T>();
    Pointer<T> result;
    if (Platform.isWindows) {
        result = winHeapAlloc(processHeap, /*flags=*/ 0, totalSize).cast();
    } else {
        result = posixMalloc(totalSize).cast();
    }
    if (result.address == 0) {
        throw ArgumentError("Could not allocate $totalSize bytes.");
    }
    return result;
}

final void free(Pointer ptr) {
    posixFree(ptr);
}