import Image from 'next/image';

export default function App() {
    return (
        <main className="flex min-h-screen flex-col items-center justify-between p-24">
            <Image
                src="https://i.imgur.com/MK3eW3Am.jpg"
                width={500}
                height={500}
                alt="Katherine Johnson"
            />
        </main>
    );
}
