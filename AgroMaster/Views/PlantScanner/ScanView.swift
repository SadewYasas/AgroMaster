import SwiftUI
import PhotosUI

struct ScanView: View {
    @StateObject var viewModel = CameraViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        header
                        diagnosticsLabel
                        titleSection
                        imageUploadArea
                        sampleImageLink
                        analyzeButton
                        scanningTipsCard
                        Spacer(minLength: 80)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
                .background(Color.appBackground)

                floatingCameraButton
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $viewModel.showResult) {
                if let result = viewModel.scanResult, let image = viewModel.selectedImage {
                    ScanResultView(image: image, result: result)
                }
            }
            .onChange(of: viewModel.photoPickerItem) { _, newItem in
                Task {
                    await viewModel.handlePickerSelection(newItem)
                }
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.textPrimary)
                    .frame(width: 44, height: 44)
                    .background(Color.surfaceLight)
                    .clipShape(Circle())
            }

            Spacer()

            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 36))
                .foregroundColor(.surfaceDark)
        }
        .padding(.top, 8)
    }

    // MARK: - Diagnostics Label

    private var diagnosticsLabel: some View {
        Text("AI DIAGNOSTICS")
            .font(.label)
            .tracking(2)
            .foregroundColor(.accentBrown)
    }

    // MARK: - Title

    private var titleSection: some View {
        Text("Scan your crops")
            .font(.heading1)
            .foregroundColor(.textPrimary)
    }

    // MARK: - Image Upload Area

    private var imageUploadArea: some View {
        VStack(spacing: 20) {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 240)
                    .clipped()
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.primaryGreen.opacity(0.3), lineWidth: 2)
                    )
                    .overlay(alignment: .topTrailing) {
                        Button {
                            viewModel.reset()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.5), radius: 4)
                        }
                        .padding(12)
                    }
            } else {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.lightGreenTint.opacity(0.5))
                            .frame(width: 80, height: 80)
                            .shadow(color: Color.primaryGreen.opacity(0.2), radius: 12, y: 4)

                        Image(systemName: "camera.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.primaryGreen)
                    }

                    Text("Upload or take a photo")
                        .font(.heading3)
                        .foregroundColor(.textPrimary)

                    Text("Position the affected leaf area in clear, natural lighting")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)

                    PhotosPicker(
                        selection: $viewModel.photoPickerItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        HStack(spacing: 8) {
                            Image(systemName: "photo.on.rectangle.angled")
                            Text("Select Photo")
                                .font(.button)
                        }
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(
                                colors: [.primaryGreen, .secondaryGreen],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 32)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.surfaceLight)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(
                    style: StrokeStyle(lineWidth: 1.5, dash: viewModel.selectedImage == nil ? [8, 6] : [])
                )
                .foregroundColor(viewModel.selectedImage == nil ? Color.surfaceDark : .clear)
        )
    }

    // MARK: - Sample Image Link

    private var sampleImageLink: some View {
        HStack {
            Spacer()
            Button {
                viewModel.loadSampleImage()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "photo")
                        .font(.system(size: 14))
                    Text("Try with sample image")
                        .font(.bodySmall)
                }
                .foregroundColor(.primaryGreen)
            }
            Spacer()
        }
    }

    // MARK: - Analyze Button

    private var analyzeButton: some View {
        Button {
            viewModel.analyzeImage()
        } label: {
            HStack(spacing: 10) {
                if viewModel.isAnalyzing {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "sparkle.magnifyingglass")
                        .font(.system(size: 18, weight: .semibold))
                }
                Text(viewModel.isAnalyzing ? "Analyzing..." : "Analyze")
                    .font(.button)
            }
            .frame(maxWidth: .infinity, minHeight: 56)
            .foregroundColor(.white)
            .background(
                viewModel.selectedImage != nil
                    ? Color.textPrimary
                    : Color.textPrimary.opacity(0.4)
            )
            .cornerRadius(12)
        }
        .disabled(viewModel.selectedImage == nil || viewModel.isAnalyzing)
    }

    // MARK: - Scanning Tips Card

    private var scanningTipsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.primaryGreen)

                Text("Scanning Tips")
                    .font(.heading4)
                    .foregroundColor(.textPrimary)
            }

            VStack(alignment: .leading, spacing: 12) {
                tipRow(number: 1, text: "Ensure the leaf or affected area fills most of the frame for accurate detection.")
                tipRow(number: 2, text: "Use natural daylight. Avoid flash or harsh artificial lighting that may wash out colors.")
                tipRow(number: 3, text: "Hold the camera steady, about 6-8 inches from the plant, and avoid blurry captures.")
            }
        }
        .padding(20)
        .background(Color.lightGreenTint.opacity(0.3))
        .cornerRadius(20)
    }

    private func tipRow(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.label)
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Color.primaryGreen)
                .clipShape(Circle())

            Text(text)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Floating Camera Button

    private var floatingCameraButton: some View {
        PhotosPicker(
            selection: $viewModel.photoPickerItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            Image(systemName: "camera.fill")
                .font(.system(size: 22))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(
                    LinearGradient(
                        colors: [.primaryGreen, .secondaryGreen],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
                .shadow(color: Color.primaryGreen.opacity(0.4), radius: 10, y: 5)
        }
        .padding(.trailing, 24)
        .padding(.bottom, 24)
    }
}

// MARK: - Preview

#Preview {
    ScanView()
}
